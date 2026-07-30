enum RepairRequestStatus {
  pending('PENDING'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const RepairRequestStatus(this.apiValue);

  final String apiValue;

  factory RepairRequestStatus.fromJson(String value) {
    return RepairRequestStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException(
        'Tr?ng th?i y?u c?u s?a ch?a kh?ng h?p l?: $value',
      ),
    );
  }

  List<RepairRequestStatus> get allowedUpdateStatuses {
    return switch (this) {
      RepairRequestStatus.pending => const [
        RepairRequestStatus.pending,
        RepairRequestStatus.inProgress,
      ],
      RepairRequestStatus.inProgress => const [
        RepairRequestStatus.inProgress,
        RepairRequestStatus.completed,
      ],
      RepairRequestStatus.completed => const [RepairRequestStatus.completed],
    };
  }

  bool canTransitionTo(RepairRequestStatus nextStatus) {
    return allowedUpdateStatuses.contains(nextStatus);
  }

  String toJson() => apiValue;
}
