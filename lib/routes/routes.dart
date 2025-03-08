import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promo_san_juan/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:promo_san_juan/screens/login_screen.dart';
import 'package:promo_san_juan/screens/onboarding/onboarding_screen.dart';

class AppRouter {
  static Future<bool> _seenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenOnboarding') ?? false;
  }

  static List<GetPage> get routes => [
        GetPage(
          name: '/',
          page: () => FutureBuilder<bool>(
            future: _seenOnboarding(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data ?? false) {
                  return const OnboardingScreen();
                  // ESTA LINEA ES PARA OMITIR EL ONBOARDING Y PASAR DIRECTO AL LOGIN
                  // return const LoginScreen();
                } else {
                  return const OnboardingScreen();
                }
              }
            },
          ),
        ),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
      ];
}
