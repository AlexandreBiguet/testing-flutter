import 'package:app/data/login.dart';

class LoginResponse {
  String _jwt;
  LoginResponse(String body) : _jwt = body;
}

class LoginRequest {
  final String _username;
  final String _password;

  LoginRequest(String username, String password)
      : _username = username,
        _password = password;
}

abstract class Login {
  Future<LoginResponse> signIn(LoginRequest req);
  Future<LoginResponse> signUp(LoginRequest req);
}

class LoginFactory {
  static Login create() {
    return FakeLogin();
  }
}
