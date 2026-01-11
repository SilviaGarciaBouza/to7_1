import 'package:flutter/material.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/viewmodels/stationViewModel.dart';
import 'package:to7_1/views/StationDetailScreen.dart';

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  String wordSearch = '';
  TextEditingController biciController = TextEditingController();
  final Stationviewmodel viewModel = Stationviewmodel(
    repository: Repository(api: Api()),
  );

  @override
  void initState() {
    super.initState();
    viewModel.loadStations();
  }

  @override
  void dispose() {
    biciController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ListenableBuilder x scuxar cambs del vm
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: const Center(
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
                icon: const Icon(Icons.refresh, color: Colors.black87),

                onPressed: viewModel.loadStations,
              ),
            ],
          ),
          body: biciBody(),
        );
      },
    );
  }

  Widget biciBody() {
    if (viewModel.isLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMesage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${viewModel.errorMesage}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: viewModel.loadStations,
                child: const Text('Volver a cargar'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.listStation.isEmpty) {
      return const Center(child: Text('No hay estaciones disponibles'));
    }

    final stationsSearch = viewModel.listStation.where((e) {
      return e.name.toUpperCase().contains(wordSearch.toUpperCase());
    }).toList();

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: biciController,
              decoration: const InputDecoration(
                hintText: "Nombre de la parada",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  wordSearch = value;
                });
              },
            ),
          ),
        ),
        const Expanded(flex: 1, child: Row()),
        Expanded(
          flex: 16,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stationsSearch.length,
            itemBuilder: (context, index) {
              final station = stationsSearch[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Tooltip(
                          message: 'Bicis disponibles',
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Tooltip(
                                message: 'Puestos vacíos',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.local_parking_rounded,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${station.numDocksAvailable}',
                                      style: const TextStyle(
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
                        const Tooltip(
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
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildLegendItem("Disponibles", Colors.white),
              buildLegendItem("> 8", Colors.green),
              buildLegendItem("< 8", Colors.orange),
              buildLegendItem(" 0 ", Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLegendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
