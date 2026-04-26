import 'package:flutter_test/flutter_test.dart';
import 'package:oko_znaniy_mobile/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const OkoZnaniyApp());
    await tester.pumpAndSettle();
    expect(find.byType(OkoZnaniyApp), findsOneWidget);
  });
}
