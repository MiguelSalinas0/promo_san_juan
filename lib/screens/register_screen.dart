import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Expresión regular para validar la contraseña
  final String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'; // Mínimo 8 caracteres, al menos una letra y un número

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  'Registrarse',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFF00ADB5),
                      ),
                ),
                const SizedBox(height: 30.0),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Input de nombre
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu nombre';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Input de apellido
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Apellido',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu apellido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Input de DNI
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'DNI',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu DNI';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Input de correo
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu correo';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Input de contraseña
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu contraseña';
                            } else if (!RegExp(passwordPattern).hasMatch(value)) {
                              return 'La contraseña debe tener al menos 8 caracteres, incluyendo una letra y un número';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Confirmar contraseña
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // Botón de registro
                      SizedBox(
                        width: width,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Navega a la pantalla de inicio
                              Get.offAllNamed('/home');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color(0xFF00ADB5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),

                // ¿Ya tienes una cuenta? Iniciar sesión
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    child: const Text(
                      '¿Ya tienes una cuenta? Iniciar sesión',
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
