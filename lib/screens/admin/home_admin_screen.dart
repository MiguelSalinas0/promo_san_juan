import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';
import 'package:promo_san_juan/widgets/commerce_card.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  Future<List<Comercio>> _cargarComercios() async {
    return await DatabaseHelper.instance.getComercios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Comercios')
      ),
      body: FutureBuilder<List<Comercio>>(
        future: _cargarComercios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los comercios'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron comercios'));
          }

          final comercios = snapshot.data!;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: comercios.length,
            itemBuilder: (context, index) {
              final comercio = comercios[index];
              return CommerceCard(
                id: comercio.id,
                nombre: comercio.name,
                descripcion: comercio.descripcion,
                urlImagen: comercio.imagePath,
                isAdmin: true,
              );
            },
          );
        },
      ),
    );
  }
}
