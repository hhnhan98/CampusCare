import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../data/repositories/repair_request_repository.dart';
import '../data/services/repair_request_api_service.dart';

final repairRequestApiServiceProvider = Provider<RepairRequestApiService>((
  ref,
) {
  final dio = ref.watch(dioProvider);

  return RepairRequestApiService(dio);
});

final repairRequestRepositoryProvider = Provider<RepairRequestRepository>((
  ref,
) {
  final apiService = ref.watch(repairRequestApiServiceProvider);

  return RepairRequestRepository(apiService: apiService);
});
