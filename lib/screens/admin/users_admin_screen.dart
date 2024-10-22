import 'package:flutter/material.dart';

class UsersAdminScreen extends StatelessWidget {
  const UsersAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador')),
      body: const Center(child: Text('Pantalla de Usuarios')),
    );
  }
}
