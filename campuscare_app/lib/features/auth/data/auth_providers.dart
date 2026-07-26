import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import 'auth_api_service.dart';
import 'auth_repository.dart';
import 'auth_storage_providers.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthApiService(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiService: ref.watch(authApiServiceProvider),
    tokenStorage: ref.watch(authTokenStorageProvider),
  );
});
