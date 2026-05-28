import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('example app smoke test', (tester) async {
    await tester.pumpWidget(const ScreenXExampleApp());
    await tester.pump();
    expect(find.text('screenx demo'), findsOneWidget);
  });
}
