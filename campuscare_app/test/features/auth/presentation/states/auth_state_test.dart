import 'package:campuscare_app/features/auth/presentation/states/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthState', () {
    test('initial state', () {
      const state = AuthState();

      expect(state.status, AuthStatus.initial);
      expect(state.errorMessage, isNull);
      expect(state.isLoading, isFalse);
      expect(state.isAuthenticated, isFalse);
    });

    test('loading state', () {
      const state = AuthState(status: AuthStatus.loading);

      expect(state.isLoading, isTrue);
    });

    test('authenticated state', () {
      const state = AuthState(status: AuthStatus.authenticated);

      expect(state.isAuthenticated, isTrue);
    });

    test('copyWith', () {
      const state = AuthState();

      final next = state.copyWith(status: AuthStatus.loading);

      expect(next.status, AuthStatus.loading);
    });

    test('clear error', () {
      const state = AuthState(
        status: AuthStatus.failure,
        errorMessage: 'Sai mật khẩu',
      );

      final cleared = state.copyWith(clearError: true);

      expect(cleared.errorMessage, isNull);
    });
  });
}
