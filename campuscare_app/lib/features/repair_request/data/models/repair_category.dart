enum RepairCategory {
  electrical('ELECTRICAL'),
  water('WATER'),
  airConditioner('AIR_CONDITIONER'),
  internet('INTERNET'),
  furniture('FURNITURE'),
  other('OTHER');

  const RepairCategory(this.apiValue);

  final String apiValue;

  factory RepairCategory.fromJson(String value) {
    return RepairCategory.values.firstWhere(
      (category) => category.apiValue == value,
      orElse: () =>
          throw FormatException('Danh mục sửa chữa không hợp lệ: $value'),
    );
  }

  String toJson() => apiValue;
}
