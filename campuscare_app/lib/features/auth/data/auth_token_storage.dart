import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStorage {
  AuthTokenStorage(this._preferences);

  static const String _accessTokenKey = 'access_token';

  final SharedPreferences _preferences;

  String? readAccessToken() {
    final token = _preferences.getString(_accessTokenKey)?.trim();

    if (token == null || token.isEmpty) {
      return null;
    }

    return token;
  }

  Future<void> saveAccessToken(String accessToken) async {
    final normalizedToken = accessToken.trim();

    if (normalizedToken.isEmpty) {
      throw ArgumentError.value(
        accessToken,
        'accessToken',
        'Access token không được để trống',
      );
    }

    final isSaved = await _preferences.setString(
      _accessTokenKey,
      normalizedToken,
    );

    if (!isSaved) {
      throw StateError('Không thể lưu access token');
    }
  }

  Future<void> clearAccessToken() async {
    final isRemoved = await _preferences.remove(_accessTokenKey);

    if (!isRemoved && _preferences.containsKey(_accessTokenKey)) {
      throw StateError('Không thể xóa access token');
    }
  }
}
