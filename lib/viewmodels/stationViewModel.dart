import 'package:flutter/material.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/Station.dart';

class Stationviewmodel extends ChangeNotifier {
  Stationviewmodel({required this.repository});
  final Repository repository;
  List<Station> listStation = [];
  bool isLoad = false;
  String? errorMesage;
  Future<void> loadStations() async {
    ///// Al recibir la orden de la UI, el ViewModel cambia su estado.
    isLoad = true;
    //Limpiamos errores anteriores
    errorMesage = null;
    //avsar pra por el spinner
    ///// Notifica a la UI para que muestre el estado de carga
    notifyListeners();
    try {
      //Esperamos que el Repository y la Api funciones
      ///// El ViewModel traslada la petición al Repository.
      listStation = await repository.getListStation();
    } catch (e) {
      //Capturamos de errores de la API o el Repository
      ///// Si algo falla abajo, el ViewModel captura el error y lo prepara para la UI.
      errorMesage = e.toString();
      listStation = [];
    } finally {
      isLoad = false;
      ///// Avisamos a la UI de que el proceso ha terminado para que actualice la pantalla.
      notifyListeners();
    }
  }
}
