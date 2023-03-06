import 'package:app/features/authenticate/domain/user.dart';
import 'package:app/features/authenticate/repository/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String storedAuthKey = "stored-auth-key";

const String fakeAuthKey = "1234";
const String fakeEmail = "toto@gmail.com";

class FakeAuth implements AuthRepository {
  final _storage = const FlutterSecureStorage();

  Future<User> _helper(String email) {
    return Future.delayed(const Duration(seconds: 3), () {
      return User(email: email);
    });
  }

  @override
  Future<User> signIn(String email, String password) async {
    User? storedUser = await getUser();
    if (storedUser != null) {
      return storedUser;
    }

    return _helper(email);
  }

  @override
  Future<User?> signOut() async {
    await _storage.delete(key: storedAuthKey);
    return null;
  }

  @override
  Future<User> signUp(String email, String password) async {
    if (email == fakeEmail) {
      await _storage.write(key: storedAuthKey, value: fakeAuthKey);
    }

    return _helper(email);
  }

  @override
  Future<User?> getUser() async {
    var value = await _storage.read(key: storedAuthKey);

    if (value == null) {
      return null;
    }

    if (value == "1234") {
      return const User(email: fakeEmail);
    }

    return null;
  }
}
