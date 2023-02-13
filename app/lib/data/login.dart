import 'package:app/logic/login/login.dart';

class FakeLogin implements Login {
  @override
  Future<LoginResponse> signIn(LoginRequest req) async {
    return Future.delayed(
        const Duration(seconds: 1), () => LoginResponse("hello"));
  }

  @override
  Future<LoginResponse> signUp(LoginRequest req) async {
    return Future.delayed(
        const Duration(seconds: 1), () => LoginResponse("hello"));
  }
}
