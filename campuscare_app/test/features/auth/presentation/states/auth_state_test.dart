import 'package:campuscare_app/features/auth/data/auth_user.dart';
import 'package:campuscare_app/features/auth/presentation/states/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const manager = AuthUser(
    id: 2,
    username: 'manager01',
    fullName: 'Quản lý',
    studentCode: 'MANAGER01',
    role: 'MANAGER',
  );

  group('AuthState', () {
    test('initial state', () {
      const state = AuthState();

      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isLoading, isFalse);
      expect(state.isAuthenticated, isFalse);
      expect(state.isManager, isFalse);
    });

    test('authenticated manager state', () {
      const state = AuthState(status: AuthStatus.authenticated, user: manager);

      expect(state.isAuthenticated, isTrue);
      expect(state.isManager, isTrue);
    });

    test('authenticated status without user is not authenticated', () {
      const state = AuthState(status: AuthStatus.authenticated);

      expect(state.isAuthenticated, isFalse);
      expect(state.isManager, isFalse);
    });

    test('copyWith can clear user and error', () {
      const state = AuthState(
        status: AuthStatus.failure,
        user: manager,
        errorMessage: 'Lỗi',
      );

      final next = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      );

      expect(next.status, AuthStatus.unauthenticated);
      expect(next.user, isNull);
      expect(next.errorMessage, isNull);
    });
  });
}
