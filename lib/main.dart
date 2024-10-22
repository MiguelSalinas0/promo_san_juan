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
        primaryColor: const Color.fromARGB(255, 255, 255, 255),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF00ADB5),
          selectionHandleColor: Color(0xFF00ADB5),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
