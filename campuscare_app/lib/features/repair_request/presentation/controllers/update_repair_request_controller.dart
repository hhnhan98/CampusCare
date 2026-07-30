import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/repair_request_status.dart';
import '../../providers/repair_request_providers.dart';
import '../states/update_repair_request_state.dart';

final updateRepairRequestControllerProvider =
    AsyncNotifierProvider<
      UpdateRepairRequestController,
      UpdateRepairRequestState
    >(UpdateRepairRequestController.new);

class UpdateRepairRequestController
    extends AsyncNotifier<UpdateRepairRequestState> {
  @override
  Future<UpdateRepairRequestState> build() async {
    return const UpdateRepairRequestState();
  }

  Future<void> updateStatus({
    required int repairRequestId,
    required RepairRequestStatus status,
    String? managerNote,
  }) async {
    state = const AsyncData(
      UpdateRepairRequestState(status: UpdateRepairRequestStatus.loading),
    );

    try {
      final repository = ref.read(repairRequestRepositoryProvider);
      final normalizedManagerNote = managerNote?.trim();

      final response = await repository.updateRepairRequestStatus(
        id: repairRequestId,
        status: status,
        managerNote:
            normalizedManagerNote == null || normalizedManagerNote.isEmpty
            ? null
            : normalizedManagerNote,
      );

      state = AsyncData(
        UpdateRepairRequestState(
          status: UpdateRepairRequestStatus.success,
          repairRequest: response.repairRequest,
        ),
      );
    } catch (error) {
      state = AsyncData(
        UpdateRepairRequestState(
          status: UpdateRepairRequestStatus.failure,
          errorMessage: _extractErrorMessage(error),
        ),
      );
    }
  }

  String _extractErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Không thể cập nhật yêu cầu. Vui lòng thử lại.';
  }
}
