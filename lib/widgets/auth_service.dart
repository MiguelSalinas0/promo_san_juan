// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/models/models.dart';
import 'package:promo_san_juan/widgets/admin_main_screen.dart';
import 'package:promo_san_juan/widgets/commerce_main_screen.dart';
import 'package:promo_san_juan/widgets/user_main_screen%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  
  // Método privado para guardar el ID del comercio
  Future<void> _saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('commerceId', id);
  }

  // Método para obtener el ID del comercio almacenado
  static Future<int?> getCommerceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('commerceId');
  }

  static Future<void> login(
      BuildContext context, String email, String password) async {
    User? user = await DatabaseHelper.instance.login(email, password);

    if (user != null) {
      switch (user.role) {
        case 'comercio':
          // Verificar si el ID no es nulo antes de guardarlo
          if (user.id != null) {
            AuthService()._saveId(user.id!);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CommerceMainScreen()),
          );
          break;
        case 'usuario':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserMainScreen()),
          );
          break;
        case 'admin':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminMainScreen()),
          );
          break;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email o contraseña incorrecto')),
      );
    }
  }
}
