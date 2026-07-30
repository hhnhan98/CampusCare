enum CreateRepairRequestStatus { initial, loading, success, failure }

class CreateRepairRequestState {
  const CreateRepairRequestState({
    this.status = CreateRepairRequestStatus.initial,
    this.errorMessage,
  });

  final CreateRepairRequestStatus status;
  final String? errorMessage;

  bool get isLoading => status == CreateRepairRequestStatus.loading;

  bool get isSuccess => status == CreateRepairRequestStatus.success;

  CreateRepairRequestState copyWith({
    CreateRepairRequestStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateRepairRequestState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
