import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to7_1/main.dart' as app;
import 'package:to7_1/views/StationListScreen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Prueba de sistema (integration_test)', () {
    testWidgets(
      'Flujo básico: cargar lista, buscar parada y navegación al detalle',
      ((WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
      title: 'BiciCoruña Práctica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const StationListScreen(),
    ));
       // app.main();
        await tester.pumpAndSettle();
        expect(find.text('BiciCoruña'), findsOneWidget);

        expect(find.byType(TextField), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'Plaza De Pontevedra');
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(ListTile, 'Plaza De Pontevedra'),
          findsOneWidget,
        );

        await tester.tap(find.widgetWithText(ListTile, 'Plaza De Pontevedra'));

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.directions_bike), findsWidgets);
        expect(find.text('Capacidad'), findsWidgets);
      }),
    );
  });
}
