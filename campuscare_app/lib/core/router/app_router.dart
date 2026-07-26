import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';

abstract final class AppRoutes {
  static const String login = '/login';

  AppRoutes._();
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
