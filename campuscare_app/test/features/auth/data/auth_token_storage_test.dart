import 'package:campuscare_app/features/auth/data/auth_token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthTokenStorage', () {
    late SharedPreferences preferences;
    late AuthTokenStorage tokenStorage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      preferences = await SharedPreferences.getInstance();
      tokenStorage = AuthTokenStorage(preferences);
    });

    test('returns null when access token does not exist', () {
      expect(tokenStorage.readAccessToken(), isNull);
    });

    test('saves and reads normalized access token', () async {
      await tokenStorage.saveAccessToken('  sample-token  ');

      expect(tokenStorage.readAccessToken(), 'sample-token');
    });

    test('clears saved access token', () async {
      await tokenStorage.saveAccessToken('sample-token');
      await tokenStorage.clearAccessToken();

      expect(tokenStorage.readAccessToken(), isNull);
    });

    test('throws ArgumentError when saving an empty token', () async {
      expect(() => tokenStorage.saveAccessToken('   '), throwsArgumentError);
    });
  });
}
