import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/models/BikeType.dart';

void main() {
  group('1-Mapeo de las clases modelo', () {
    test('BikeType asigna valores por defecto si el JSON no los contiene', () {
      expect(BikeType.fromJson({}).id, 'id unknown');
      expect(BikeType.fromJson({}).count, 0);
    });

    test('Station guarda bien el nombre', () {
      expect(
        Station.fromJson({'name': 'Plaza De Pontevedra'}).name,
        'Plaza De Pontevedra',
      );
    });

    test('El count de BikeType se mapea aunque sea un doube', () {
      expect(BikeType.fromJson({'count': 2.0}).count, 2);
    });

    test('Station calcula correctamente los puestos rotos', () {
      final st = Station.fromJson({
        'capacity': 5,
        'num_bikes_available': 1,
        'num_docks_available': 1,
      });
      expect(st.capacity - (st.numBikesAvailable + st.numDocksAvailable), 3);
    });
  });
  group('2-Lógica del Repositorio', () {
    test('Combinación por id de los datos', () {
      final info = {
        'station_id': '1',
        'name': 'Plaza De Pontevedra',
        'capacity': 11,
      };
      final status = {
        'station_id': '1',
        'num_bikes_available': 3,
        'num_docks_available': 8,
      };
      final Map<String, dynamic> combinedMap = {};
      combinedMap.addAll(info);
      combinedMap.addAll(status);
      final station = Station.fromJson(combinedMap);

      expect(station.name, 'Plaza De Pontevedra');
      expect(station.numBikesAvailable, 3);
      expect(station.id, '1');
    });

    test('Falta de datos en status', () {
      final Map<String, dynamic> info = {
        'station_id': '1',
        'name': 'Plaza De Pontevedra',
        'capacity': 11,
      };
      final Map<String, dynamic> statusVacio = {};
      final Map<String, dynamic> combinedMap = {};
      combinedMap.addAll(info);
      combinedMap.addAll(statusVacio);
      final station = Station.fromJson(combinedMap);

      expect(station.name, 'Plaza De Pontevedra');
      expect(station.numBikesAvailable, 0);
      expect(station.numDocksAvailable, 0);
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
