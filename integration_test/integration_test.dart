import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to7_1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Flujo completo: Carga, búsqueda y navegación al detalle', (
    WidgetTester tester,
  ) async {
    // 1. ARRANCAR LA APP
    app.main();
    await tester.pumpAndSettle();
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Espera para carga de API
    await tester.pumpAndSettle();

    // 2. BUSCAR UNA ESTACIÓN
    final Finder searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Obelisco');
    await tester.pumpAndSettle();

    // 3. SELECCIONAR LA ESTACIÓN
    // TRUCO: Buscamos el texto 'Obelisco' que sea DESCENDIENTE del ListView.
    // De esta forma ignoramos el texto que está en la barra de búsqueda.
    final Finder stationInList = find.descendant(
      of: find.byType(ListView),
      matching: find.textContaining('Obelisco'),
    );

    // Verificamos que ahora sí solo encuentra uno en la lista
    expect(stationInList, findsOneWidget);

    // Pulsamos en la estación de la lista
    await tester.tap(stationInList);

    // Esperamos a que termine la animación de navegación al detalle
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // 4. VALIDAR EL DETALLE
    // Comprobamos que estamos en la pantalla de detalle buscando elementos únicos
    expect(find.textContaining('Vacíos'), findsOneWidget);
    expect(find.byIcon(Icons.pedal_bike), findsOneWidget);

    print('--- TEST COMPLETADO CON ÉXITO ---');
  });
}
