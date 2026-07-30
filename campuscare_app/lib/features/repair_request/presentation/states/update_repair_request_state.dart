import '../../data/models/repair_request.dart';

enum UpdateRepairRequestStatus { initial, loading, success, failure }

class UpdateRepairRequestState {
  const UpdateRepairRequestState({
    this.status = UpdateRepairRequestStatus.initial,
    this.repairRequest,
    this.errorMessage,
  });

  final UpdateRepairRequestStatus status;
  final RepairRequest? repairRequest;
  final String? errorMessage;

  bool get isLoading => status == UpdateRepairRequestStatus.loading;

  bool get isSuccess => status == UpdateRepairRequestStatus.success;

  UpdateRepairRequestState copyWith({
    UpdateRepairRequestStatus? status,
    RepairRequest? repairRequest,
    bool clearRepairRequest = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UpdateRepairRequestState(
      status: status ?? this.status,
      repairRequest: clearRepairRequest
          ? null
          : (repairRequest ?? this.repairRequest),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
