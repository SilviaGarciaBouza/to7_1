import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:to7_1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Prueba de Sistema ', () {
    testWidgets('Cargar lista, filtrar por nombre y navegar al detalle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const app.MyApp());

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('BiciCoruña'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Pontevedra');
      await tester.pumpAndSettle();

      final paradaFinder = find.textContaining('Pontevedra');
      expect(paradaFinder, findsAtLeastNWidgets(1));

      await tester.tap(paradaFinder.first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.electric_bike), findsWidgets);

      expect(find.textContaining('Capacidad total'), findsOneWidget);
    });
  });
}
