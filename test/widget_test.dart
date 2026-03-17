import 'package:flutter_test/flutter_test.dart';
import 'package:arteria_fit_app/main.dart';

void main() {
  testWidgets('Counter increment smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ArteriaFitApp());
    // Test básico para verificar que la app compila y carga
    expect(find.text('Arteria Fit'), findsOneWidget);
  });
}
