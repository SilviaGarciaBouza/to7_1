import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';

void main() {
  group('Test de integracion ascendente', () {
    test('La Api devuelve datos', () async {
      final api = Api();
      expect(await api.getStationInformation(), isNotNull);
      expect(await api.getStationStatus(), isNotNull);
    });

    test('El Repository convierte los datos a modelos', () async {
      final api = Api();
      final repository = Repository(api: api);

      final estaciones = await repository.getListStation();
      expect(estaciones.isNotEmpty, isTrue);
    });
  });
}
