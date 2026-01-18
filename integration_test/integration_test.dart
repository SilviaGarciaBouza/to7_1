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
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Obelisco');
    await tester.pumpAndSettle();
    // Seleccionamos la estación
    expect(find.textContaining('Obelisco'), findsWidgets);
    // Pulsamos en la estación de la lista
    await tester.tap(find.textContaining('Obelisco').at(1));
    // Esperamos a que termine la animación de navegación al detalle
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    // Comprobamos que estamos en la pantalla de detalle
    expect(find.textContaining('Vacíos'), findsOneWidget);
    expect(find.byIcon(Icons.pedal_bike), findsOneWidget);
  });
}
