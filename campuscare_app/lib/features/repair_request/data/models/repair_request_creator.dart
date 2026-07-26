class RepairRequestCreator {
  const RepairRequestCreator({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.studentCode,
  });

  final int id;
  final String username;
  final String fullName;
  final String? studentCode;
  final String role;

  factory RepairRequestCreator.fromJson(Map<String, dynamic> json) {
    return RepairRequestCreator(
      id: json['id'] as int,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      studentCode: json['studentCode'] as String?,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'studentCode': studentCode,
      'role': role,
    };
  }
}
