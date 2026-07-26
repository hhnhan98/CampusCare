import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_providers.dart';
import 'auth_token_storage.dart';

final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);

  return AuthTokenStorage(preferences);
});
