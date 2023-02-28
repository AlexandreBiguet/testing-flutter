import 'package:app/features/authenticate/domain/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<User?> signOut();
  Future<User?> getUser();
}
