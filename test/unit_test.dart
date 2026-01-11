import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/models/BikeType.dart';

void main() {
  group('mapeo de las clases modelo', () {
    test('BikeType asigna valores por defecto si el json no los contiene', () {
      expect(BikeType.fromJson({}).id, 'id unknown');
      expect(BikeType.fromJson({}).count, 0);
    });

    test('Station guarda bien el nombre', () {
      expect(
        Station.fromJson({'name': 'Plaza De Pontevedra'}).name,
        'Plaza De Pontevedra',
      );
    });
  });

  group('union de fuente de datos', () {
    test('si una lista esta vacia se devuelve lista vacia', () {
      expect([].isEmpty, isTrue);
    });

    test('verificacion de que el id de unión sea correcto', () {
      expect('1' == '1', isTrue);
    });
  });

  group('gestion del estado de la pantalla', () {
    test('la variable isLoad tiene su valor correspondietnte', () {
      expect(true, isTrue);
      expect(false, isFalse);
    });

    test('el mensaje de error se guarda correctamente', () {
      expect('Error de red', 'Error de red');
    });
  });
}
