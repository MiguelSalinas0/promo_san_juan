import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:promo_san_juan/models/models.dart';

class CustomCarousel extends StatelessWidget {
  final List<Promocion> items;
  final Function(int promotionId) onItemTapped;

  const CustomCarousel({
    super.key,
    required this.items,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: false,
        enableInfiniteScroll: true,
      ),
      items: items.map((item) => _buildCarouselItem(item)).toList(),
    );
  }

  Widget _buildCarouselItem(Promocion item) {
    return GestureDetector(
      onTap: () => onItemTapped(item.id!),
      child: Stack(
        children: [
          _buildImage('assets/carousel/frame_background.jpg'),
          _buildOverlay(),
          _buildTextContent(item),
        ],
      ),
    );
  }

  // Widget separado para la imagen con bordes redondeados
  Widget _buildImage(String imagePath) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  // Widget para la capa oscura que se superpone sobre la imagen
  Widget _buildOverlay() {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Widget para el texto que aparece sobre la imagen
  Widget _buildTextContent(Promocion item) {
    return Positioned.fill(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.title,
              style: _titleTextStyle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              item.description,
              style: _subtitleTextStyle(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Función para el estilo del título
  TextStyle _titleTextStyle() {
    return const TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: Colors.black45,
          offset: Offset(3.0, 3.0),
        ),
      ],
    );
  }

  // Función para el estilo del subtítulo
  TextStyle _subtitleTextStyle() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white70,
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: Colors.black45,
          offset: Offset(3.0, 3.0),
        ),
      ],
    );
  }
}
