import 'package:flutter_test/flutter_test.dart';
import 'package:flutterprojects/main.dart';

void main() {

  testWidgets(
    'Memory Match app loads correctly',
        (WidgetTester tester) async {

      await tester.pumpWidget(
        const MemoryMatchApp(),
      );

      expect(
        find.text('Memory Match'),
        findsOneWidget,
      );
    },
  );
}