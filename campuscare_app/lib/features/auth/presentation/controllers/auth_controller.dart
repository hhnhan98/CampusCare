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
    final repository = ref.read(authRepositoryProvider);
    final hasAccessToken = repository.hasAccessToken();

    return AuthState(
      status: hasAccessToken
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.login(username: username, password: password);

      state = const AsyncData(AuthState(status: AuthStatus.authenticated));
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

    final repository = ref.read(authRepositoryProvider);
    final hasAccessToken = repository.hasAccessToken();

    state = AsyncData(
      AuthState(
        status: hasAccessToken
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      ),
    );
  }

  String _extractErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Đã xảy ra lỗi, vui lòng thử lại.';
  }
}
