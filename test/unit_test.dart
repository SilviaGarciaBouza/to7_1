import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/models/BikeType.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/viewmodels/stationViewModel.dart';

void main() {
  group('GRUPO 1: Pruebas de los modelos BikeType y Station', () {
    test('Prueba BikeType datos reales', () {
      final bike = BikeType.fromJson({'vehicle_type_id': '1', 'count': 2});
      expect(bike.count, 2);
      expect(bike.id, '1');
    });

    test('Prueba BikeType datos vacios', () {
      final bike = BikeType.fromJson({});
      expect(bike.id, 'id unknown');
      expect(bike.count, 0);
    });

    test('Prueba BikeType paso de double a int', () {
      final bike = BikeType.fromJson({'vehicle_type_id': '1', 'count': 2.0});
      expect(bike.count, 2);
    });

    test('Prueba Station datos reales', () {
      final station = Station.fromJson({
        'station_id': '1',
        'name': 'Name',
        'capacity': 8,
        'num_bikes_available': 2,
        'num_docks_available': 4,
        'last_reported': 12334,
        'vehicle_types_available': [],
      });
      expect(station.id, '1');
      expect(station.name, 'Name');
    });

    test('Prueba Station datos vacios', () {
      final station = Station.fromJson({'station_id': '1', 'capacity': 8});
      expect(station.lastReported, 0);
      expect(station.name, 'name unknown');
    });

    test('Prueba Station paso de double a int', () {
      final station = Station.fromJson({
        'station_id': '1',
        'name': 'Name',
        'capacity': 8,
        'num_bikes_available': 2.8,
        'num_docks_available': 4.0,
      });
      expect(station.numBikesAvailable, 2);
      expect(station.numDocksAvailable, 4);
    });
  });

  group('GRUPO 2: Pruebas del ViewModel', () {
    late Stationviewmodel vmSuccess;
    late Stationviewmodel vmError;

    setUp(() {
      vmSuccess = Stationviewmodel(repository: FakeRepoSuccess());
      vmError = Stationviewmodel(repository: FakeRepoError());
    });

    test('Prueba viewmodel isLoad', () async {
      expect(vmSuccess.isLoad, false);
      final loadTask = vmSuccess.loadStations();
      expect(vmSuccess.isLoad, true);
      await loadTask;
      expect(vmSuccess.isLoad, false);
    });

    test('Prueba viewModel que no falla', () async {
      await vmSuccess.loadStations();
      expect(vmSuccess.listStation.length, 1);
      expect(vmSuccess.errorMesage, isNull);
    });

    test('Prueba viewModel que falla', () async {
      await vmError.loadStations();

      expect(vmError.errorMesage, 'Prueba de error');
    });
  });

  group('GRUPO 3: Pruebas de Repository', () {
    late Repository repo;
    late Repository repoError;

    setUp(() {
      repo = Repository(api: FakeApiSuccess());
      repoError = Repository(api: FakeApiError());
    });

    test('El Repository combina correctamente los datos', () async {
      final listStation = await repo.getListStation();
      expect(listStation.isNotEmpty, true);
      expect(listStation[0].name, 'Prueba');
      expect(listStation[0].numBikesAvailable, 5);
    });

    test('El Repository lanza la excepción si ocurre un error.', () async {
      expect(() => repoError.getListStation(), throwsException);
    });
  });
}

class FakeApiSuccess extends Api {
  @override
  Future<Map<String, dynamic>> getJson(Uri url) async {
    if (url.toString().contains('station_information')) {
      return {
        'data': {
          'stations': [
            {'station_id': '1', 'name': 'Prueba', 'capacity': 10},
          ],
        },
      };
    } else {
      return {
        'data': {
          'stations': [
            {
              'station_id': '1',
              'num_bikes_available': 5,
              'num_docks_available': 5,
            },
          ],
        },
      };
    }
  }
}

class FakeApiError extends Api {
  @override
  Future<Map<String, dynamic>> getJson(Uri url) async {
    throw Exception('Error de red simulado');
  }
}

class FakeRepoSuccess extends Repository {
  FakeRepoSuccess() : super(api: FakeApiSuccess());
  @override
  Future<List<Station>> getListStation() async {
    return [
      Station(
        id: '1',
        name: 'Prueba',
        numBikesAvailable: 5,
        numDocksAvailable: 5,
        capacity: 10,
        lastReported: 0,
        availableTypes: [],
      ),
    ];
  }
}

class FakeRepoError extends Repository {
  FakeRepoError() : super(api: FakeApiError());
  @override
  Future<List<Station>> getListStation() async {
    throw Exception('Prueba de error');
  }
}
