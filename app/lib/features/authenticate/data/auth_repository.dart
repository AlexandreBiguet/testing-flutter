import 'package:app/features/authenticate/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
class AuthRepository extends _$AuthRepository {
  @override
  FutureOr<User?> build() async {
    return null;
  }

  Future<User> _helper(String email) {
    return Future.delayed(const Duration(seconds: 3), () {
      return User(email: email);
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _helper(email));
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _helper(email));
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return Future.delayed(const Duration(seconds: 3), () {
        return null;
      });
    });
  }
}
