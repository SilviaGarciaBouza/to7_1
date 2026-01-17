import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to7_1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Flujo completo: Carga, búsqueda y navegación al detalle', (
    WidgetTester tester,
  ) async {
    // Arrancamos la aplicación
    app.main();
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    // Esperamos a q se cargue
    await tester.pumpAndSettle();
    // Buscamos una estacion
    final Finder searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Obelisco');
    await tester.pumpAndSettle();
    // Seleccionamos la estación
    final Finder stationInList = find.descendant(
      of: find.byType(ListView),
      matching: find.textContaining('Obelisco'),
    );
    expect(stationInList, findsOneWidget);
    // Pulsamos en la estación de la lista
    await tester.tap(stationInList);
    // Esperamos a que termine la animación de navegación al detalle
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    // Comprobamos que estamos en la pantalla de detalle
    expect(find.textContaining('Vacíos'), findsOneWidget);
    expect(find.byIcon(Icons.pedal_bike), findsOneWidget);


  });
}

