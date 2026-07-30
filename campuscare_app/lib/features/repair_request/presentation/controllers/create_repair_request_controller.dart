import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/repair_category.dart';
import '../../data/models/repair_priority.dart';
import '../../providers/repair_request_providers.dart';
import '../states/create_repair_request_state.dart';

final createRepairRequestControllerProvider =
    AsyncNotifierProvider<
      CreateRepairRequestController,
      CreateRepairRequestState
    >(CreateRepairRequestController.new);

class CreateRepairRequestController
    extends AsyncNotifier<CreateRepairRequestState> {
  @override
  Future<CreateRepairRequestState> build() async {
    return const CreateRepairRequestState();
  }

  Future<void> createRepairRequest({
    required String title,
    required String description,
    required RepairCategory category,
    required RepairPriority priority,
    required String campus,
    required String location,
    String? imagePath,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(repairRequestRepositoryProvider);

      await repository.createRepairRequest(
        title: title,
        description: description,
        category: category,
        priority: priority,
        campus: campus,
        location: location,
        imagePath: imagePath,
      );

      state = const AsyncData(
        CreateRepairRequestState(status: CreateRepairRequestStatus.success),
      );
    } catch (error) {
      state = AsyncData(
        CreateRepairRequestState(
          status: CreateRepairRequestStatus.failure,
          errorMessage: _extractErrorMessage(error),
        ),
      );
    }
  }

  String _extractErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Không thể tạo yêu cầu sửa chữa. Vui lòng thử lại.';
  }
}
