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
        'Trạng thái yêu cầu sửa chữa không hợp lệ: $value',
      ),
    );
  }

  String toJson() => apiValue;
}
