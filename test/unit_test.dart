import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/models/BikeType.dart';
import 'package:to7_1/viewmodels/stationViewModel.dart';

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
  group('2-Lógica del Repository', () {
    test('Unión de los datos de las dos fuentes por su id.', () {
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
    test('Gestión de errores cuando faltan datos del estado.', () {
      final Map<String, dynamic> info = {
        'station_id': '1',
        'name': 'Plaza De Pontevedra',
        'capacity': 11,
      };
      final Map<String, dynamic> status = {};
      final Map<String, dynamic> combinedMap = {};
      combinedMap.addAll(info);
      combinedMap.addAll(status);
      final station = Station.fromJson(combinedMap);
      expect(station.name, 'Plaza De Pontevedra');
      expect(station.numBikesAvailable, 0);
      expect(station.numDocksAvailable, 0);
    });
  });

  test('Comportamiento ante listas vacías.', () {
    final Map<String, dynamic> status = {};
    final Map<String, dynamic> info = {};
    final Map<String, dynamic> combinedMp = {};
    combinedMp.addAll(info);
    combinedMp.addAll(status);
    final station = Station.fromJson(combinedMp);

    expect(station.name, 'name unknown');
    expect(station.numBikesAvailable, 0);
  });

  test('Número correcto de estaciones.', () {
    final List<dynamic> infoList = [
      {'station_id': '1', 'name': 'Plaza De Pontevedra', 'capacity': 8},
      {'station_id': '2', 'name': 'Aquarium', 'capacity': 9},
      {'station_id': '3', 'name': 'Plaza de Lugo', 'capacity': 10},
    ];

    final List<dynamic> statusList = [
      {'station_id': '1', 'num_bikes_available': 3},
      {'station_id': '2', 'num_bikes_available': 4},
    ];

    final resultList = infoList.map((e) {
      final String id = e['station_id'];
      final statusElement = statusList.firstWhere(
        (element) => element['station_id'] == id,
        orElse: () => <String, dynamic>{},
      );

      final Map<String, dynamic> combinedMap = {};
      combinedMap.addAll(e);
      combinedMap.addAll(statusElement);
      return Station.fromJson(combinedMap);
    }).toList();
    expect(resultList.length, 3);
  });

  Stationviewmodel vm = Stationviewmodel(repository: SuccessRepository());
  Stationviewmodel vmError = Stationviewmodel(repository: ErrorRepository());
  group('3-Gestión del estado de la pantalla', () {
    test('Control del estado de carga.', () async {
      expect(vm.isLoad, false);
      final action = vm.loadStations();
      expect(vm.isLoad, true);
      await action;
      expect(vm.isLoad, false);
    });

    test('Gestión de errores en la carga.', () async {
      await vmError.loadStations();
      expect(vmError.errorMesage, isNotNull);
      expect(vmError.listStation.length, 0);
    });
  });
}

class ErrorRepository extends Repository {
  ErrorRepository() : super(api: Api());
  @override
  Future<List<Station>> getListStation() async {
    return Future.error('Error 500');
  }
}

class SuccessRepository extends Repository {
  SuccessRepository() : super(api: Api());
  @override
  Future<List<Station>> getListStation() async {
    return [
      Station(
        id: '1',
        name: 'Plaza de Pontevedra',
        capacity: 10,
        numBikesAvailable: 5,
        numDocksAvailable: 5,
        lastReported: 0,
        availableTypes: [],
      ),
    ];
  }
}
