import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to7_1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Prueba de Sistema: Flujo Bicicoruña', () {
    testWidgets('Carga, búsqueda y navegación a detalle de estación', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);

      final Finder searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Obelisco');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final Finder stationResult = find.textContaining('OBELISCO');
      expect(stationResult, findsWidgets);

      await tester.tap(stationResult.first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Actualizado:'), findsOneWidget);
      expect(find.byIcon(Icons.pedal_bike), findsWidgets);

      print(
        "Prueba finalizada con éxito: Estación Obelisco encontrada y visualizada.",
      );
    });
  });
}
