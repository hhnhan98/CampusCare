abstract final class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String authorizationHeader = 'Authorization';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);

  static String? resolveResourceUrl(String? resourceUrl) {
    final normalized = resourceUrl?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    final resourceUri = Uri.tryParse(normalized);

    if (resourceUri != null && resourceUri.hasScheme) {
      return normalized;
    }

    final apiUri = Uri.parse(baseUrl);
    final serverOrigin = apiUri.replace(path: '/', query: null, fragment: null);

    return serverOrigin.resolve(normalized).toString();
  }

  ApiConstants._();
}
