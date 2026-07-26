abstract final class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String authorizationHeader = 'Authorization';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);

  ApiConstants._();
}
