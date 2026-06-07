import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uni_life_rsvp_exam/features/auth/domain/repository/auth_repository_impl.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final _repo = AuthRepositoryImpl();

  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signIn(email: email, password: password),
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signUp(name: name, email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signOut());
  }
}
