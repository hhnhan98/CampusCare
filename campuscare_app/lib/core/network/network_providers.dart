import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_storage_providers.dart';
import 'dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(authTokenStorageProvider);

  final dio = DioClient.create(tokenStorage: tokenStorage);

  ref.onDispose(dio.close);

  return dio;
});
