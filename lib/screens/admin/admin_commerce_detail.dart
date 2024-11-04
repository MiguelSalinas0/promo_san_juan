// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';

class AdminDetailScreen extends StatefulWidget {
  const AdminDetailScreen({super.key, required this.id});
  final int id;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<AdminDetailScreen> {
  ComercioDetalles? comercioDetalles;
  bool isLoading = true;
  bool isHabilitado = false;

  @override
  void initState() {
    super.initState();
    _loadComercioDetalles();
  }

  // Función para cargar los detalles desde la base de datos
  Future<void> _loadComercioDetalles() async {
    final detalles = await DatabaseHelper.instance.getComercioDetallesById(widget.id);
    setState(() {
      comercioDetalles = detalles;
      isHabilitado = detalles?.isHabilitado ?? false;
      isLoading = false;
    });
  }

  // Función para cambiar el estado de habilitación
  Future<void> _toggleHabilitado(bool value) async {
    setState(() {
      isHabilitado = value;
    });

    if (comercioDetalles != null) {
      comercioDetalles!.isHabilitado = value;
      await DatabaseHelper.instance.updateComercioHabilitacion(widget.id, value);
    }
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
                            const Icon(Icons.location_on,
                                color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                comercioDetalles!.direccion,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
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
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Horario
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(
                              comercioDetalles!.horario,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Estado de habilitación del comercio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Habilitado',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Switch(
                              value: isHabilitado,
                              onChanged: (value) {
                                _toggleHabilitado(value);
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Título sección 'Donde Encontrarnos'
                        // const Text(
                        //   'Donde Encontrarnos',
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.blueGrey,
                        //   ),
                        // ),

                        // const SizedBox(height: 10),
                      ],
                    ),
                  ),
      ),
    );
  }
}
