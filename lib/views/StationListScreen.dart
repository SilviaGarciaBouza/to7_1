import 'dart:io';

import 'package:flutter/material.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/views/StationDetailScreen.dart';

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  String wordSearch = '';
  TextEditingController biciController = TextEditingController();

  final Repository repository = Repository(api: Api());
  List<Station> stations = [];
  List<Station> stationsSearch = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final datos = await repository.getListStation();
      setState(() {
        stations = datos;
        stationsSearch = stations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Center(
          child: Text(
            'BiciCoruña',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87),
            onPressed: loadData,
          ),
        ],
      ),
      body: biciBody(),
    );
  }

  Widget biciBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $errorMessage', textAlign: TextAlign.center),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: loadData,
                child: Text('Volver a cargar'),
              ),
            ],
          ),
        ),
      );
    }

    if (stations.isEmpty) {
      return Center(child: Text('No hay estaciones disponibles'));
    }

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: TextField(
            autofocus: true,
            controller: biciController,
            decoration: InputDecoration(
              //labelText: "Buscar",
              hintText: "Nombre de la parada",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                wordSearch = value;
                if (wordSearch.isEmpty) {
                  stationsSearch = stations;
                } else {
                  stationsSearch = stations
                      .where(
                        (e) => e.name.toUpperCase().contains(
                          wordSearch.toUpperCase(),
                        ),
                      )
                      .toList();
                }
              });
            },
          ),
        ),
        Expanded(flex: 1, child: Row()),
        Expanded(
          flex: 16,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: stationsSearch.length,
            itemBuilder: (context, index) {
              final station = stationsSearch[index];

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: (station.numBikesAvailable == 0)
                        ? Colors.red
                        : (station.numBikesAvailable < 8)
                        ? Colors.orange
                        : Colors.green,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),

                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StationDetailScreen(station: station),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Tooltip(
                          message: 'Bicis disponibles',
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,

                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${station.numBikesAvailable}',
                                style: TextStyle(
                                  color: (station.numBikesAvailable == 0)
                                      ? Colors.red
                                      : (station.numBikesAvailable < 8)
                                      ? Colors.orange
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),

                              Tooltip(
                                message: 'Puestos vacíos',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.local_parking_rounded,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${station.numDocksAvailable}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Tooltip(
                          message: 'Ver detalles',
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
