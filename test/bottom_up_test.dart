import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/viewmodels/stationViewModel.dart';

void main() {
  test('Prueba de Integración Bottom-Up', () async {
    final mockClient = MockClient((request) async {
      final mapListStationsJson = {
        'data': {
          'stations': [
            {
              'station_id': '1',
              'name': 'Prueba',
              'capacity': 20,
              'num_bikes_available': 8,
              'num_docks_available': 7,
            },
          ],
        },
      };
      return http.Response(jsonEncode(mapListStationsJson), 200);
    });
final mockClientError = MockClient((request) async {  
      return http.Response(jsonEncode({}), 400);
    });

    
    final api = Api(client: mockClient);
    final repository = Repository(api: api);
    final viewModel = Stationviewmodel(repository: repository);
    await viewModel.loadStations();
    
    final station = viewModel.listStation.first;

    expect(station.id, '1');
    expect(station.name, 'Prueba');
    expect(station.numBikesAvailable, 8);
    expect(viewModel.listStation.length, 1);
    expect(viewModel.isLoad, false);
    expect(viewModel.errorMesage, isNull);
  });
}
