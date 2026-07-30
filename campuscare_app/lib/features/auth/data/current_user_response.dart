import 'auth_user.dart';

class CurrentUserResponse {
  const CurrentUserResponse({required this.message, required this.user});

  final String message;
  final AuthUser user;

  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Phản hồi thông tin người dùng không hợp lệ');
    }

    final userData = data['user'];

    if (userData is! Map<String, dynamic>) {
      throw const FormatException('Thông tin người dùng không hợp lệ');
    }

    final message = json['message'];

    if (message is! String || message.trim().isEmpty) {
      throw const FormatException('Phản hồi thông tin người dùng không hợp lệ');
    }

    return CurrentUserResponse(
      message: message.trim(),
      user: AuthUser.fromJson(userData),
    );
  }
}
