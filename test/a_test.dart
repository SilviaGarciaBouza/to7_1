import 'dart:ffi';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/BikeType.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/viewmodels/stationViewModel.dart';

void main() {
  group('Pruebas de los modelos BikeType y Station.', () {
    test('Prueba BikeType datos reales', () {
      expect(BikeType.fromJson({'vehicle_type_id': '1', 'count': 2}).count, 2);
      expect(BikeType.fromJson({'vehicle_type_id': '1', 'count': 2}).id, '1');
    });
    test('Prueba BikeType datos vacios', () {
      expect(BikeType.fromJson({}).id, 'id unknown');
      expect(BikeType.fromJson({}).count, 0);
    });
    test('Prueba BikeType paso de double a int', () {
      expect(
        BikeType.fromJson({'vehicle_type_id': '1', 'count': 2.0}).count,
        2,
      );
    });
    test('Prueba Station datos reales', () {
      expect(
        Station.fromJson({
          'station_id': '1',
          'name': 'Name',
          'capacity': 8,
          'num_bikes_available': 2,
          'num_docks_available': 4,
          'last_reported': 12334,
          'vehicle_types_available': [],
        }).id,
        '1',
      );
      expect(
        Station.fromJson({
          'station_id': '1',
          'name': 'Name',
          'capacity': 8,
          'num_bikes_available': 2,
          'num_docks_available': 4,
          'last_reported': 12334,
          'vehicle_types_available': [],
        }).name,
        'Name',
      );
    });
    test('Prueba Station datos vacios', () {
      expect(
        Station.fromJson({
          'station_id': '1',
          'name': 'Name',
          'capacity': 8,
          'num_bikes_available': 2,
          'num_docks_available': 4,
          'vehicle_types_available': [],
        }).lastReported,
        0,
      );
      expect(
        Station.fromJson({
          'station_id': '1',
          'capacity': 8,
          'num_bikes_available': 2,
          'num_docks_available': 4,
          'last_reported': 12334,
          'vehicle_types_available': [],
        }).name,
        'name unknown',
      );
    });
    test('Prueba Station paso de double a int', () {
      expect(
        Station.fromJson({
          'station_id': '1',
          'name': 'Name',
          'capacity': 8,
          'num_bikes_available': 2.8,
          'num_docks_available': 4,
        }).numBikesAvailable,
        2,
      );
      expect(
        Station.fromJson({
          'station_id': '1',
          'capacity': 8,
          'num_bikes_available': 2,
          'num_docks_available': 4.0,
          'last_reported': 12334,
        }).numDocksAvailable,
        4,
      );
    });
  });

  group('Prueba viewModel', () {
    var vm = Stationviewmodel(
      repository: RespositoryTest(is_Successfull: true),
    );
    var vmError = Stationviewmodel(
      repository: RespositoryTest(is_Successfull: false),
    );
    test('Prueba viewmodel isLoad', () async {
      expect(vm.isLoad, false);
      final load = vm.loadStations();
      expect(vm.isLoad, true);
      await load;
      expect(vm.isLoad, false);
    });
    test('Prueba viewModel que no falla', () async {
      var listStation = await vm.loadStations();
      expect(vm.listStation.length, 1);
    });
    test('Prueba viewModel que  falla', () async {
      var errorResult = await vmError.loadStations();
      expect(vmError.errorMesage, 'Exception: Prueba de error');
    });
  });

  group('Pruebas de Repository.', () {
    var repo = Repository(api: ApiTest());
    var repoError = Repository(api: ApiError());
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

class ApiTest extends Api {
  @override
  Future<Map<String, dynamic>> getJson(Uri url) async {
    if (url.path.contains('station_information')) {
      return {
        'data': {
          'stations': [
            {'station_id': '1', 'name': 'Prueba', 'capacity': 10},
          ],
        },
      };
    }
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

class ApiError extends Api {
  @override
  Future<Map<String, dynamic>> getJson(Uri url) async {
    throw Exception('Fallo de red');
  }
}

class RespositoryTest extends Repository {
  final bool is_Successfull;
  RespositoryTest({required this.is_Successfull}) : super(api: Api());

  Future<List<Station>> getListStation() async {
    if (!is_Successfull) {
      throw Exception('Prueba de error');
    }
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
