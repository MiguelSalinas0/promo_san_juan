import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promo_san_juan/models/models.dart';
import 'package:promo_san_juan/screens/usuario/promotion_detail_screen.dart';
import 'package:promo_san_juan/widgets/commerce_card.dart';
import 'package:promo_san_juan/widgets/custom_carousel.dart';
import 'package:promo_san_juan/helper/database_helper.dart';
import 'package:promo_san_juan/screens/usuario/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Comercio>> _cargarComercios() async {
    return await DatabaseHelper.instance.getComerciosUser();
  }

  Future<List<Promocion>> _cargarPromociones() async {
    return await DatabaseHelper.instance.getAllPromotions();
  }

  void _navigateToPromotionDetail(int promotionId) {
    Get.to(() => PromotionDetailScreen(id: promotionId));
  }

  // Método para navegar a la pantalla de búsqueda
  void _navigateToSearchScreen() {
    Get.to(() => const SearchScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo San Juan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: _navigateToSearchScreen,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        'Buscar comercios...',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Carrusel (FutureBuilder separado)
            FutureBuilder<List<Promocion>>(
              future: _cargarPromociones(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error al cargar los elementos del carrusel'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No se encontraron elementos del carrusel'));
                }

                final carouselItems = snapshot.data!;
                return CustomCarousel(
                  items: carouselItems,
                  onItemTapped: _navigateToPromotionDetail,
                );
              },
            ),

            const SizedBox(height: 10),

            // Título de Comercios Destacados
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Comercios Destacados',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),

            // Lista de comercios (otro FutureBuilder separado)
            FutureBuilder<List<Comercio>>(
              future: _cargarComercios(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error al cargar los comercios'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No se encontraron comercios'));
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
                      isAdmin: false,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
