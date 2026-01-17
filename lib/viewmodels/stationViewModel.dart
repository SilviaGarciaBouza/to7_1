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
    isLoad = true;
    //Limpiamos errores anteriores
    errorMesage = null;
    //avsar pra por el spinner
    notifyListeners();
    try {
      //Esperamos que el Repository y la Api funciones
      listStation = await repository.getListStation();
    } catch (e) {
      //Capturamos de errores de la API o el Repository
      errorMesage = e.toString();
      listStation = [];
    } finally {
      isLoad = false;
      notifyListeners();
    }
  }
}
