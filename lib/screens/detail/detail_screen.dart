import 'package:flutter/material.dart';

// Simulación de una base de datos o fuente de datos
const Map<int, Map<String, String>> comercioDetalles = {
  1: {
    "nombre": "La Buena Mesa",
    "url_imagen": "assets/comercios/la_buena_mesa.jpg",
    "descripcion": "Restaurante de cocina tradicional con un toque moderno.",
    "direccion": "Calle Falsa 123",
    "telefono": "123-456-7890",
    "horario": "9:00 AM - 11:00 PM"
  },
  2: {
    "nombre": "Supermercado Central",
    "url_imagen": "assets/comercios/supermercado_central.jpg",
    "descripcion": "Supermercado con productos frescos y de calidad.",
    "direccion": "Avenida Siempre Viva 456",
    "telefono": "987-654-3210",
    "horario": "8:00 AM - 10:00 PM"
  },
  3: {
    "nombre": "Café Aromas",
    "url_imagen": "assets/comercios/cafe_aromas.jpg",
    "descripcion": "Cafetería acogedora especializada en café gourmet.",
    "direccion": "Plaza Central, Local 8",
    "telefono": "555-123-9876",
    "horario": "7:00 AM - 8:00 PM"
  },
};

class DetailScreen extends StatelessWidget {
  final int id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final comercio = comercioDetalles[id]; // Obtiene los detalles del comercio por id

    if (comercio == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Comercio'),
        ),
        body: const Center(
          child: Text('Comercio no encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(comercio['nombre'] ?? 'Detalles del Comercio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              comercio['url_imagen'] ?? '',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              comercio['nombre'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              comercio['descripcion'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Dirección: ${comercio['direccion'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Teléfono: ${comercio['telefono'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Horario: ${comercio['horario'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
