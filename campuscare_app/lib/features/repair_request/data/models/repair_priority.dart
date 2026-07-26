enum RepairPriority {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH');

  const RepairPriority(this.apiValue);

  final String apiValue;

  factory RepairPriority.fromJson(String value) {
    return RepairPriority.values.firstWhere(
      (priority) => priority.apiValue == value,
      orElse: () =>
          throw FormatException('Mức độ ưu tiên không hợp lệ: $value'),
    );
  }

  String toJson() => apiValue;
}
