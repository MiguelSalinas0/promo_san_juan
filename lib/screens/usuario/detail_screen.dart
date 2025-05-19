import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';

const accessToken = 'pk.eyJ1IjoibGlua2kwMSIsImEiOiJjbTEyYW5rZHAwOXlxMmpvajluanp5N3hrIn0.r4FH60zZeLINaSHBaK1HBQ';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id});
  final int id;

  @override
  // ignore: library_private_types_in_public_api
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ComercioDetalles? comercioDetalles;
  bool isLoading = true;
  LatLng? ubicacion;

  @override
  void initState() {
    super.initState();
    _loadComercioDetalles();
  }

  // Función para cargar los detalles desde la base de datos
  Future<void> _loadComercioDetalles() async {
    final detalles = await DatabaseHelper.instance.getComercioDetallesById(widget.id);
    final ubicacionDB = await DatabaseHelper.instance.getLocationById(widget.id);

    setState(() {
      comercioDetalles = detalles;
      ubicacion = ubicacionDB;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Comercio'),
        ),
        body: SingleChildScrollView(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : comercioDetalles == null
                  ? const Center(child: Text('Comercio no encontrado'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                comercioDetalles!.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Nombre del comercio
                          Text(
                            comercioDetalles!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Descripción
                          Text(
                            comercioDetalles!.descripcion,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Dirección
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  comercioDetalles!.direccion,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Teléfono
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                comercioDetalles!.telefono,
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Horario
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.blueAccent),
                              const SizedBox(width: 8),
                              Text(
                                comercioDetalles!.horario,
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Título seccion 'Donde Encontrarnos'
                          const Text(
                            'Donde Encontrarnos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),

                          const SizedBox(height: 10),

                          ubicacion != null
                              ? Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FlutterMap(
                                      options: MapOptions(
                                        initialCenter: ubicacion!,
                                        initialZoom: 15.5,
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$accessToken',
                                          tileSize: 512,
                                          zoomOffset: -1,
                                        ),
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              width: 40,
                                              height: 40,
                                              point: ubicacion!,
                                              child: const Icon(
                                                  Icons.location_pin,
                                                  color: Colors.red,
                                                  size: 40),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const Text('Ubicación no disponible'),
                        ],
                      )),
        ));
  }
}
