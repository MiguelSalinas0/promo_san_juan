import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promo_san_juan/widgets/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // const LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.85; // El ancho común para inputs y botones

    return Scaffold(
      body: SingleChildScrollView(
        // Envuelve el contenido en un SingleChildScrollView
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido horizontalmente
              children: [
                Material(
                  elevation: 5.0, // Elevación del círculo
                  shape: const CircleBorder(), // Forma circular
                  child: Container(
                    padding: const EdgeInsets.all(8.0), // Padding alrededor de la imagen
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, // Forma circular del contenedor
                    ),
                    child: Container(
                      width: 100.0, // Tamaño del círculo
                      height: 100.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, // Forma circular
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'), // Ruta a tu imagen en assets
                          fit: BoxFit.contain, // Ajusta la imagen para que se ajuste al círculo sin cubrirlo completamente
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                // Título
                Text(
                  'Promo San Juan',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: const Color(0xFF00ADB5)),
                ),

                const SizedBox(height: 30.0),

                // Input de email
                SizedBox(
                  width: width,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: Color(0xFF00ADB5)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF00ADB5),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color:Colors.grey), // Borde cuando no está en focus
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Input de contraseña
                SizedBox(
                  width: width,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: Color(0xFF00ADB5)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF00ADB5),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color:Colors.grey), // Borde cuando no está en focus
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),

                const SizedBox(height: 30.0),

                // Botón "Ingresar"
                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () {
                      AuthService.login(context, emailController.text, passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor:const Color(0xFF00ADB5), // Color principal
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 10.0),

                // Botón "Crear cuenta"
                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/register');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor:Colors.white, // Color para el botón de crear cuenta
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(color: Color(0xFF00ADB5)),
                    ),
                  ),
                ),

                const SizedBox(height: 10.0),

                // ¿Olvidaste la contraseña?
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Acción al presionar "¿Olvidaste la contraseña?"
                    },
                    child: const Text(
                      '¿Olvidaste la contraseña?',
                      style: TextStyle(color: Color(0xFF00ADB5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
