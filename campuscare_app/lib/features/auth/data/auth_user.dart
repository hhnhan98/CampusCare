class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.studentCode,
    required this.role,
  });

  final int id;
  final String username;
  final String fullName;
  final String? studentCode;
  final String role;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: _readInt(json, 'id'),
      username: _readString(json, 'username'),
      fullName: _readString(json, 'fullName'),
      studentCode: _readNullableString(json, 'studentCode'),
      role: _readString(json, 'role'),
    );
  }

  static int _readInt(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is int) {
      return value;
    }

    throw const FormatException('Dữ liệu người dùng không hợp lệ');
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    throw const FormatException('Dữ liệu người dùng không hợp lệ');
  }

  static String? _readNullableString(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value == null) {
      return null;
    }

    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    throw const FormatException('Dữ liệu người dùng không hợp lệ');
  }
}
