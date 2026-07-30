import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/auth_providers.dart';
import '../states/auth_state.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return _restoreAuthenticatedUser();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.login(
        username: username,
        password: password,
      );

      state = AsyncData(
        AuthState(status: AuthStatus.authenticated, user: response.user),
      );
    } catch (error) {
      state = AsyncData(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: _extractErrorMessage(error),
        ),
      );
    }
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);

    await repository.logout();

    state = const AsyncData(AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> restoreSession() async {
    state = const AsyncLoading();
    state = AsyncData(await _restoreAuthenticatedUser());
  }

  Future<AuthState> _restoreAuthenticatedUser() async {
    final repository = ref.read(authRepositoryProvider);

    if (!repository.hasAccessToken()) {
      return const AuthState(status: AuthStatus.unauthenticated);
    }

    try {
      final user = await repository.getCurrentUser();

      return AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      await repository.logout();

      return const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  String _extractErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Đã xảy ra lỗi, vui lòng thử lại.';
  }
}
