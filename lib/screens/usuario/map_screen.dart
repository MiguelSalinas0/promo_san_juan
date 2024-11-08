import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:promo_san_juan/helper/database_helper.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        child: Center(
          child: MapWidget(),
        ),
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  LatLng _currentPosition = const LatLng(-31.5375, -68.536389); // Ubicación predeterminada
  late MapController _mapController;
  bool _hasLocation = false;
  List<Map<String, dynamic>> _comercios = []; // Lista de comercios

  // Llama a getLocations y almacena los datos en _comercios
  Future<void> _loadComercios() async {
    final comercios = await DatabaseHelper.instance.getLocations();
    setState(() {
      _comercios = comercios;
      _hasLocation = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeLocation();
    _loadComercios();
    _startLocationUpdates(); // Inicia la actualización de la ubicación en tiempo real
  }


  void _initializeLocation() async {
    LatLng position = await _determinePosition();
    setState(() {
      _currentPosition = position;
      _hasLocation = true;
    });
  }

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _currentPosition;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _currentPosition;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return _currentPosition;
    }
  }

  // Actualiza la ubicación en tiempo real
  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _mapController.move(
          _currentPosition,
          _mapController.camera.zoom,
        ); // Mueve el mapa junto con el marcador
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const accessToken = 'pk.eyJ1IjoibGlua2kwMSIsImEiOiJjbTEyYW5rZHAwOXlxMmpvajluanp5N3hrIn0.r4FH60zZeLINaSHBaK1HBQ';

    return _hasLocation
        ? FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 15,
              minZoom: 5,
              maxZoom: 18,
              onMapReady: () {
                // Mover el mapa a la posición actual una vez que el mapa esté listo
                _mapController.move(_currentPosition, 15);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$accessToken',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 60,
                    height: 60,
                    point: _currentPosition,
                    child: const Icon(
                      Icons.location_on,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                  // Marcadores personalizados para los comercios
                  for (var comercio in _comercios)
                    Marker(
                      width: 80,
                      height: 80,
                      point: comercio['location'],
                      child: GestureDetector(
                        onTap: () {
                          // Mostrar información del comercio
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(comercio['name']),
                              content: Text(comercio['description']),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.store,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
