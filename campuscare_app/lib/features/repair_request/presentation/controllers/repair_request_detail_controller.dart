import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/repair_request.dart';
import '../../providers/repair_request_providers.dart';

final repairRequestDetailProvider = FutureProvider.family<RepairRequest, int>((
  ref,
  repairRequestId,
) async {
  final repository = ref.read(repairRequestRepositoryProvider);
  final response = await repository.getRepairRequestById(repairRequestId);

  return response.repairRequest;
});
