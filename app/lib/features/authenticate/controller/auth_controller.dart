import 'package:app/features/authenticate/domain/user.dart';
import 'package:app/features/authenticate/repository/auth_repository.dart';
import 'package:app/features/authenticate/repository/fake_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuth();
});

@riverpod
class AuthController extends _$AuthController {
  late AuthRepository _authRepository;

  @override
  FutureOr<User?> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
    return _authRepository.getUser();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _authRepository.signIn(email, password));
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _authRepository.signUp(email, password));
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
  }
}
