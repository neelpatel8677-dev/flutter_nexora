import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/main.dart';

void main() {
  testWidgets('Nexora login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const NexoraApp());
    await tester.pump();

    expect(find.text('Nexora'), findsOneWidget);
    expect(find.text('Student Management System'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
