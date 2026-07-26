import 'package:campuscare_app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Hiển thị màn hình đăng nhập CampusCare', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CampusCareApp()));

    await tester.pumpAndSettle();

    expect(find.text('CampusCare'), findsOneWidget);

    expect(
      find.text('Tiếp nhận và theo dõi yêu cầu sửa chữa cơ sở vật chất'),
      findsOneWidget,
    );

    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}
