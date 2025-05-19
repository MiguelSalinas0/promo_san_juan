// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

const accessToken = 'pk.eyJ1IjoibGlua2kwMSIsImEiOiJjbTEyYW5rZHAwOXlxMmpvajluanp5N3hrIn0.r4FH60zZeLINaSHBaK1HBQ';

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
  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<Position>? _positionSubscription;

  LatLng _currentPosition = const LatLng(-31.5375, -68.536389); // Ubicación predeterminada
  late MapController _mapController;
  bool _hasLocation = false;
  List<Map<String, dynamic>> _comercios = []; // Lista de comercios
  List<LatLng> _routePoints = []; // Lista para almacenar los puntos de la ruta
  LatLng? _selectedDestination; // Almacena la ubicación seleccionada por el usuario
  double? _heading; // Almacena la dirección de la brújula

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

    // Ejecutar después del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation(); // ya es async, pero esto evita problemas con permisos
    });

    _loadComercios();
    _startLocationUpdates();

    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (!mounted) return;
      setState(() {
        _heading = event.heading;
      });
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _initializeLocation() async {
    LatLng position = await _determinePosition();
    setState(() {
      _currentPosition = position;
      _hasLocation = true;
    });
  }

  Future<LatLng> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('El servicio de ubicación está desactivado.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('El permiso de ubicación fue denegado.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('El permiso de ubicación está permanentemente denegado.');
      }

      // Esperar posición
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return _currentPosition;
    }
  }

  // Función para mover el mapa hacia el norte
  void _orientMapNorth() {
    _mapController.rotate(0); // Esto orienta el mapa al norte
  }

  void _startLocationUpdates() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Permiso de ubicación denegado. No se inicia el stream.');
      return;
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen(
      (Position position) {
        if (!mounted) return;
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });

        if (_selectedDestination != null) {
          _getRoute(_selectedDestination!.latitude, _selectedDestination!.longitude);
        }
      },
      onError: (error) {
        print('Error en el stream de ubicación: $error');

        if (mounted) {
          setState(() {
            _hasLocation = false;
          });
        }

        // Opcional: cancelar la suscripción si no tiene sentido continuar
        _positionSubscription?.cancel();
      },
    );
  }

  // Función para obtener la ruta utilizando Mapbox Directions API
  Future<void> _getRoute(double destinationLat, double destinationLon) async {
    final originLat = _currentPosition.latitude;
    final originLon = _currentPosition.longitude;

    // Generar la URL para la API de Mapbox Directions
    final String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/$originLon,$originLat;$destinationLon,$destinationLat?alternatives=true&geometries=geojson&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'];

      // Convertir las coordenadas en una lista de LatLng
      List<LatLng> routePoints = route.map<LatLng>((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();

      // Limpiar los puntos que ya recorriste (opcional)
      routePoints = _cleanRoute(routePoints, _currentPosition);

      setState(() {
        _routePoints = routePoints; // Actualizamos la lista de puntos de la ruta
      });
    } else {
      throw Exception('Error al obtener la ruta');
    }
  }

  List<LatLng> _cleanRoute(List<LatLng> rutaCompleta, LatLng actual) {
    return rutaCompleta.skipWhile((punto) {
      final distancia = Geolocator.distanceBetween(
        actual.latitude,
        actual.longitude,
        punto.latitude,
        punto.longitude,
      );
      return distancia < 10; // Consideramos que esos puntos ya fueron recorridos
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _hasLocation
        ? Stack(
            children: [
              FlutterMap(
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Flecha que se rota según la orientación
                            if (_heading != null)
                              Transform.rotate(
                                angle: (_heading! * (math.pi / 180)) + math.pi,
                                child: const Icon(
                                  Icons.navigation,
                                  size: 30,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            // Puedes ajustar la posición de la flecha más arriba o más abajo
                          ],
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
                                    Column(
                                      // Coloca los botones uno debajo del otro
                                      children: [
                                        Align(
                                          alignment: Alignment
                                              .centerRight, // Alinea el texto del botón a la derecha
                                          child: TextButton(
                                            onPressed: () {
                                              _selectedDestination = LatLng(
                                                comercio['location'].latitude,
                                                comercio['location'].longitude,
                                              );

                                              // Llamar la función para obtener la ruta desde la ubicación actual al comercio
                                              _getRoute(_selectedDestination!.latitude,_selectedDestination!.longitude);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cómo llegar'),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight, // Alinea el texto del botón a la derecha
                                          child: TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cerrar'),
                                          ),
                                        ),
                                      ],
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
                  // Agregar PolylineLayer para dibujar la ruta
                  if (_routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints, // Las coordenadas de la ruta
                          strokeWidth: 2.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                ],
              ),
              // Caja de botones en la esquina inferior derecha
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: const Color(0xFF00ADB5),
                      heroTag: 'center_location',
                      mini: true,
                      onPressed: () {
                        _mapController.move(
                            _currentPosition,
                            _mapController.camera.zoom); // Mueve el mapa junto con el marcador
                      },
                      child: const Icon(Icons.my_location),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      backgroundColor: const Color(0xFF00ADB5),
                      heroTag: 'north',
                      mini: true,
                      onPressed: _orientMapNorth,
                      child: const Icon(Icons.explore),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
