import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({required this.message, this.code, this.statusCode});

  final String message;
  final String? code;
  final int? statusCode;

  factory ApiException.fromDioException(DioException exception) {
    final response = exception.response;
    final responseData = response?.data;

    if (responseData is Map<String, dynamic>) {
      final errorData = responseData['error'];

      return ApiException(
        message: _readMessage(
          responseData,
          fallback: _messageFromType(exception.type),
        ),
        code: errorData is Map<String, dynamic>
            ? errorData['code']?.toString()
            : null,
        statusCode: response?.statusCode,
      );
    }

    return ApiException(
      message: _messageFromType(exception.type),
      statusCode: response?.statusCode,
    );
  }

  static String _readMessage(
    Map<String, dynamic> data, {
    required String fallback,
  }) {
    final message = data['message'];

    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    return fallback;
  }

  static String _messageFromType(DioExceptionType type) {
    return switch (type) {
      DioExceptionType.connectionTimeout =>
        'Không thể kết nối đến máy chủ. Vui lòng thử lại.',
      DioExceptionType.sendTimeout =>
        'Gửi dữ liệu lên máy chủ quá thời gian cho phép.',
      DioExceptionType.receiveTimeout =>
        'Máy chủ phản hồi quá thời gian cho phép.',
      DioExceptionType.transformTimeout =>
        'Xử lý dữ liệu phản hồi quá thời gian cho phép.',
      DioExceptionType.connectionError =>
        'Không thể kết nối đến máy chủ CampusCare.',
      DioExceptionType.cancel => 'Yêu cầu đã bị hủy.',
      DioExceptionType.badCertificate =>
        'Chứng chỉ bảo mật của máy chủ không hợp lệ.',
      DioExceptionType.badResponse => 'Máy chủ không thể xử lý yêu cầu.',
      DioExceptionType.unknown => 'Đã xảy ra lỗi kết nối không xác định.',
    };
  }

  @override
  String toString() => message;
}
