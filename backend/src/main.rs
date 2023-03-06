use std::collections::HashMap;

use axum::{
    extract::{Json, State},
    routing::{get, post},
    Router, Server,
};

use std::sync::{Arc, RwLock};

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let state = AppState::default();

    let router = Router::new()
        .route("/", get(get_root))
        .route("/auth/signup", post(post_signup))
        .with_state(state.clone());
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
    tracing::info!("Sign up user with email: {}", payload.email);

    if let Some(_user) = fetch_user(&state, payload.email.clone()).await {
        tracing::info!("User {} already exists", payload.email);
    } else {
        let new_user = create_user(state, payload).await;
        tracing::info!("New user created: {:?}", new_user);
    }

    Json(UserCreated {
        token: "1234".to_string(),
    })
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
