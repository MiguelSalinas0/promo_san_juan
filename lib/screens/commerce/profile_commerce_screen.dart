// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCommerceScreen extends StatelessWidget {
  const ProfileCommerceScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comercio')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Ver información'),
            onTap: () {
              // Aquí agregar la acción para ver la información del comercio
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart),
            title: const Text('Estadísticas'),
            onTap: () {
              // Aquí agregar la acción para ver las estadísticas
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar información'),
            onTap: () {
              // Aquí agregar la acción para editar la información
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            onTap: () {
              // Aquí agregar la acción para gestionar las notificaciones
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
