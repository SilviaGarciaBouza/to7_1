import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to7_1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Prueba de sistema', () {
    testWidgets('Cargar datos, buscar parada y navegar al detalle', ((
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const app.MyApp());

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('BiciCoruña'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Pontevedra');
      await tester.pumpAndSettle();

      final paradaFinder = find.textContaining('Pontevedra');
      expect(paradaFinder, findsAtLeastNWidgets(1));

      await tester.tap(paradaFinder.first);
      await tester.pumpAndSettle();

      // expect(find.byIcon(Icons.pedal_bike), findsOneWidget);
      expect(find.text('Vacíos'), findsOneWidget);
      expect(find.textContaining('estación'), findsOneWidget);
    }));
  });
}
