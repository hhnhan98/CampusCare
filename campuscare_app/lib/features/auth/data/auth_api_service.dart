import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import 'login_request.dart';
import 'login_response.dart';

class AuthApiService {
  AuthApiService(this._dio);

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      final responseData = response.data;

      if (responseData == null) {
        throw const ApiException(
          message: 'Máy chủ không trả về dữ liệu đăng nhập',
          code: 'INVALID_LOGIN_RESPONSE',
        );
      }

      try {
        return LoginResponse.fromJson(responseData);
      } on FormatException {
        throw const ApiException(
          message: 'Dữ liệu đăng nhập từ máy chủ không hợp lệ',
          code: 'INVALID_LOGIN_RESPONSE',
        );
      }
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
