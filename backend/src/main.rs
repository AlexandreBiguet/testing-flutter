use std::collections::HashMap;

use axum::{
    extract::{Json, State},
    routing::{get, post},
    Router, Server,
};
use chrono::{Duration, Utc};
use tracing::Level;

use std::sync::{Arc, RwLock};

use tower_http::cors::{Any, CorsLayer};

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        // should be configurable
        // .json()
        .with_max_level(Level::DEBUG)
        .init();

    let state = AppState::default();

    // https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    // https://www.html5rocks.com/static/images/cors_server_flowchart.png
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Headers
    // https://developer.mozilla.org/en-US/docs/Glossary/Preflight_request
    // https://developer.mozilla.org/en-US/docs/Glossary/CORS-safelisted_request_header
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type

    let cors = CorsLayer::new()
        // TODO: configure this
        // .allow_origin("http://localhost:53552".parse::<HeaderValue>().unwrap())
        .allow_origin(Any)
        .allow_methods([http::Method::GET, http::Method::POST])
        .allow_headers([http::header::CONTENT_TYPE]);

    let router = Router::new()
        .route("/", get(get_root))
        .route("/auth/signup", post(post_signup))
        .with_state(state.clone())
        .layer(cors);
    let server = Server::bind(&"0.0.0.0:1234".parse().unwrap()).serve(router.into_make_service());
    let address = server.local_addr();

    tracing::info!("Listening on {address}");

    server.await.unwrap();
}

#[tracing::instrument]
async fn get_root() -> &'static str {
    "Hello from axum"
}

#[derive(serde::Deserialize, Clone)]
struct CreateUser {
    email: String,
    password: String,
}

#[derive(serde::Serialize)]
struct UserCreated {
    token: String,
}

#[derive(Clone, Debug)]
struct User {
    id: String,
    email: String,
    hashed_password: String, // Todo should be hash
}

#[axum::debug_handler]
async fn post_signup(
    State(state): State<AppState>,
    Json(payload): Json<CreateUser>,
) -> Json<UserCreated> {
    // TODO: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
    // TODO: https://crates.io/crates/pbkdf2
    // TODO: https://www.shuttle.rs/blog/2022/08/11/authentication-tutorial

    tracing::info!("Sign up user with email: {}", payload.email);

    let mut user = fetch_user(&state, payload.email.clone()).await;
    user.get_or_insert(create_user(state, payload).await);

    // TODO: should add Set-Cookie to response
    //   https://stormpath.com/blog/where-to-store-your-jwts-cookies-vs-html5-web-storage

    Json(UserCreated {
        token: create_token(user.unwrap()),
    })
}

fn get_issuer() -> String {
    let mut issuer = env!("CARGO_PKG_NAME").to_string();
    issuer.push_str(env!("CARGO_PKG_VERSION"));
    issuer
}

fn create_token(user: User) -> String {
    // https://www.rfc-editor.org/rfc/rfc7519

    use hmac::{Hmac, Mac};
    use jwt::SignWithKey;
    use sha2::Sha256;
    use std::collections::BTreeMap;

    let iss = get_issuer();
    let now = Utc::now();
    let expiration_date = now.checked_add_signed(Duration::hours(1)).unwrap();
    let exp = expiration_date.to_string();
    let iat = now.to_string();

    let key: Hmac<Sha256> = Hmac::new_from_slice(b"some-secret").unwrap();
    let mut claims = BTreeMap::new();
    claims.insert("sub", &user.id);
    claims.insert("iss", &iss);
    claims.insert("exp", &exp);
    claims.insert("iat", &iat);

    claims.sign_with_key(&key).unwrap()
}

async fn fetch_user(state: &AppState, email: String) -> Option<User> {
    tracing::info!(
        "fetching user with email: {} from {} known accounts",
        email,
        state.users.read().unwrap().keys().len()
    );

    for (k, v) in state.users.read().unwrap().iter() {
        tracing::info!("{}, {:?}", k, v);
    }

    if let Some(value) = state.users.read().unwrap().get(&email) {
        Some(value.clone())
    } else {
        None
    }
}

#[derive(Clone, Default)]
struct AppState {
    users: Arc<RwLock<HashMap<String, User>>>,
}

async fn create_user(state: AppState, user: CreateUser) -> User {
    let new_user = User {
        id: user.email.clone(),
        email: user.email,
        hashed_password: user.password, // TODO hash
    };

    state
        .users
        .write()
        .unwrap()
        .insert(new_user.id.clone(), new_user.to_owned());

    new_user.clone()
}
