import 'package:flutter/material.dart';
import 'package:promo_san_juan/widgets/commerce_card.dart';
import 'package:promo_san_juan/providers/comercios_provider.dart';
import 'package:promo_san_juan/widgets/custom_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> comercios = []; // Lista para almacenar los comercios

  @override
  void initState() {
    super.initState();
    _cargarComercios(); // Cargar los comercios al iniciar el widget
  }

  // Método para cargar los datos desde el archivo JSON
  void _cargarComercios() async {
    final data = await menuProvider
        .cargarData(); // Llama al método cargarData del proveedor
    setState(() {
      comercios = data; // Asigna los datos cargados a la lista de comercios
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> carouselItems = [
      'assets/carousel/frame_5.png',
      'assets/carousel/frame_6.png',
      'assets/carousel/frame_7.png'
    ]; // Los elementos del carrusel (ejemplo)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo San Juan'),
      ),
      body: comercios.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Muestra un loader mientras se cargan los datos
          : SingleChildScrollView(
              child: Column(
                children: [
                  CustomCarousel(items: carouselItems),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Comercios Destacados',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Column(
                    children: comercios.map((comercio) {
                      return CommerceCard(
                        id: comercio['id'], // Pasa el id del comercio
                        nombre: comercio['nombre'],
                        descripcion: comercio['descripcion'],
                        urlImagen: comercio['url_imagen'],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
