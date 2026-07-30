import 'package:campuscare_app/core/network/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiConstants.resolveResourceUrl', () {
    test('returns null for null value', () {
      expect(ApiConstants.resolveResourceUrl(null), isNull);
    });

    test('returns null for blank value', () {
      expect(ApiConstants.resolveResourceUrl('   '), isNull);
    });

    test('resolves backend relative upload path against server origin', () {
      final result = ApiConstants.resolveResourceUrl(
        '/uploads/repair-requests/example.png',
      );

      expect(
        result,
        'http://10.0.2.2:3000/uploads/repair-requests/example.png',
      );
    });

    test('keeps absolute URL unchanged', () {
      const absoluteUrl = 'https://example.com/images/example.png';

      expect(ApiConstants.resolveResourceUrl(absoluteUrl), absoluteUrl);
    });
  });
}
