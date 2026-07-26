import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../controllers/auth_controller.dart';
import '../states/auth_state.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _hasNavigated = false;

  void _handleAuthState(AuthState authState) {
    if (_hasNavigated || !mounted) {
      return;
    }

    switch (authState.status) {
      case AuthStatus.authenticated:
        _hasNavigated = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.go(AppRoutes.dashboard);
          }
        });

      case AuthStatus.unauthenticated:
      case AuthStatus.failure:
        _hasNavigated = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.go(AppRoutes.login);
          }
        });

      case AuthStatus.initial:
      case AuthStatus.loading:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsyncState = ref.watch(authControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<AuthState>>(authControllerProvider, (previous, next) {
      final authState = next.asData?.value;

      if (authState != null) {
        _handleAuthState(authState);
      }
    });

    final currentAuthState = authAsyncState.asData?.value;

    if (currentAuthState != null) {
      _handleAuthState(currentAuthState);
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.home_repair_service_rounded,
                  size: 52,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'CampusCare',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
