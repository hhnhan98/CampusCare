import 'auth_user.dart';

class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final String expiresIn;
  final AuthUser user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Phản hồi đăng nhập không hợp lệ');
    }

    final userData = data['user'];

    if (userData is! Map<String, dynamic>) {
      throw const FormatException('Thông tin người dùng không hợp lệ');
    }

    return LoginResponse(
      accessToken: _readString(data, 'accessToken'),
      tokenType: _readString(data, 'tokenType'),
      expiresIn: _readString(data, 'expiresIn'),
      user: AuthUser.fromJson(userData),
    );
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    throw const FormatException('Phản hồi đăng nhập không hợp lệ');
  }
}
