import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promo_san_juan/screens/detail/detail_screen.dart';

// Definimos el widget reutilizable
class CommerceCard extends StatelessWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final String urlImagen;

  // Constructor para recibir los datos del comercio
  const CommerceCard({
    super.key,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.urlImagen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => DetailScreen(id: id));
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: SizedBox(
                width: 100,
                height: 110,
                child: Image.asset(
                  urlImagen,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descripcion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}