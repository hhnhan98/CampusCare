import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/repair_request/presentation/pages/create_repair_request_page.dart';
import '../../features/repair_request/presentation/pages/repair_request_list_page.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String repairRequests = '/repair-requests';
  static const String createRepairRequest = '/repair-requests/create';

  AppRoutes._();
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.repairRequests,
      name: 'repair-requests',
      builder: (context, state) => const RepairRequestListPage(),
    ),
    GoRoute(
      path: AppRoutes.createRepairRequest,
      name: 'create-repair-request',
      builder: (context, state) => const CreateRepairRequestPage(),
    ),
  ],
);
