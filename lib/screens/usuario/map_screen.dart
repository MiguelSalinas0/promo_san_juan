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
  late MapController _mapController; // Controlador del mapa
  bool _hasLocation = false; // Bandera para verificar si se tiene la ubicación
  List<Map<String, dynamic>> _comercios = []; // Lista de comercios
  List<LatLng> _routePoints = []; // Lista para almacenar los puntos de la ruta
  LatLng? _selectedDestination; // Almacena la ubicación seleccionada por el usuario
  List<Map<String, dynamic>> _navigationSteps = []; // Lista para almacenar los pasos de navegación
  String? _instruccionActual; // Almacena la instrucción actual
  int _pasoActual = 0; 
  LatLng? _lastUpdatedPosition; // Almacena la última posición actualizada
  final double _minDistanceForUpdate = 20; // Metros

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
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  // Inicializa la ubicación actual
  void _initializeLocation() async {
    LatLng position = await _determinePosition();
    setState(() {
      _currentPosition = position;
      _hasLocation = true;
    });
  }

  // Función para determinar la posición actual
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

  // Función para iniciar el stream de ubicación
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
        final newPos = LatLng(position.latitude, position.longitude);

        setState(() {
          _currentPosition = newPos;
        });

        // Solo actualizar si nos movimos más de X metros desde la última vez
        if (_lastUpdatedPosition == null ||
            Geolocator.distanceBetween(
                  _lastUpdatedPosition!.latitude,
                  _lastUpdatedPosition!.longitude,
                  newPos.latitude,
                  newPos.longitude,
                ) >
                _minDistanceForUpdate) {
          _lastUpdatedPosition = newPos;

          // Verificar si hay pasos e ir actualizando la instrucción si corresponde
          if (_pasoActual < _navigationSteps.length) {
            final step = _navigationSteps[_pasoActual];
            final location = step['location'];
            final lat = location.latitude;
            final lon = location.longitude;

            final distancia = Geolocator.distanceBetween(
              newPos.latitude,
              newPos.longitude,
              lat,
              lon,
            );

            if (distancia < 30) {
              _pasoActual++;
              _actualizarInstruccion();
            }
          }

          if (_selectedDestination != null) {
            _getRoute(_selectedDestination!.latitude, _selectedDestination!.longitude);
          }
        }
      },
      onError: (error) {
        print('Error en el stream de ubicación: $error');
        if (mounted) {
          setState(() {
            _hasLocation = false;
          });
        }
        _positionSubscription?.cancel();
      },
    );
  }

  // Función para obtener la ruta desde la ubicación actual al destino y guardar los pasos con instrucciones
  Future<void> _getRoute(double destinationLat, double destinationLon) async {
    final originLat = _currentPosition.latitude;
    final originLon = _currentPosition.longitude;

    final String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/$originLon,$originLat;$destinationLon,$destinationLat?alternatives=true&geometries=geojson&steps=true&language=es&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'];

      // Convertir coordenadas
      List<LatLng> routePoints = route.map<LatLng>((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();

      // Guardar pasos con instrucciones
      final steps = data['routes'][0]['legs'][0]['steps'];
      _navigationSteps = steps.map<Map<String, dynamic>>((step) {
        final maneuver = step['maneuver'];
        return {
          'instruction': maneuver['instruction'],
          'location': LatLng(maneuver['location'][1], maneuver['location'][0]),
        };
      }).toList();

      _pasoActual = 0;
      _actualizarInstruccion();

      setState(() {
        _routePoints = _cleanRoute(routePoints, _currentPosition);
      });
    } else {
      throw Exception('Error al obtener la ruta');
    }
  }

  // Actualiza la instrucción actual
  void _actualizarInstruccion() {
    if (_pasoActual < _navigationSteps.length) {
      final instruccion = _navigationSteps[_pasoActual]['instruction'];
      setState(() {
        _instruccionActual = instruccion;
      });
    } else {
      setState(() {
        _instruccionActual = null; // Oculta cuando termina
      });
    }
  }

  // Limpia la ruta eliminando los puntos que ya fueron recorridos
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

  // Limpia la ruta y las instrucciones
  void _clearRouteAndInstructions() {
    setState(() {
      _routePoints.clear();
      _navigationSteps.clear();
      _instruccionActual = null;
      _pasoActual = 0;
      _selectedDestination = null;
    });
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
                        point: _currentPosition,
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue, // color de relleno
                            border: Border.all(
                              color: Colors.white, // contorno blanco
                              width: 3,
                            ),
                          ),
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
                                          alignment: Alignment.centerRight, // Alinea el texto del botón a la derecha
                                          child: TextButton(
                                            onPressed: () {
                                              _selectedDestination = LatLng(
                                                comercio['location'].latitude,
                                                comercio['location'].longitude,
                                              );

                                              // Llamar la función para obtener la ruta desde la ubicación actual al comercio
                                              _getRoute(_selectedDestination!.latitude, _selectedDestination!.longitude);
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
                    if (_routePoints.isNotEmpty || _instruccionActual != null)
                      FloatingActionButton(
                        heroTag: 'clear_route',
                        backgroundColor: Colors.redAccent,
                        mini: true,
                        onPressed: _clearRouteAndInstructions,
                        child: const Icon(Icons.clear),
                      ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      backgroundColor: const Color(0xFF00ADB5),
                      heroTag: 'center_location',
                      mini: true,
                      onPressed: () {
                        _mapController.move(_currentPosition, _mapController.camera.zoom); // Mueve el mapa junto con el marcador
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
              Positioned(
                top: 80,
                left: 20,
                right: 20,
                child: _instruccionActual != null
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          _instruccionActual!,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
