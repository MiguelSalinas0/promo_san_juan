import 'package:flutter/material.dart';
import 'package:promo_san_juan/routes/routes.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF00ADB5);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Promo San Juan',
      initialRoute: '/',
      getPages: AppRouter.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
        useMaterial3: true,
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}