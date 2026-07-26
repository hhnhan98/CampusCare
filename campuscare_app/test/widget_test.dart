import 'package:campuscare_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:campuscare_app/features/auth/presentation/pages/login_page.dart';
import 'package:campuscare_app/features/auth/presentation/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthController extends AuthController {
  @override
  Future<AuthState> build() async {
    return const AuthState(status: AuthStatus.unauthenticated);
  }
}

void main() {
  testWidgets('Hiển thị màn hình đăng nhập CampusCare', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(FakeAuthController.new),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.pump();

    expect(find.text('CampusCare'), findsOneWidget);
    expect(find.text('Tên đăng nhập'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}
