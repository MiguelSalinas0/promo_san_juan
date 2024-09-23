import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel extends StatelessWidget {
  // Esta lista recibirá los elementos que el carrusel mostrará
  final List<String> items;

  // Constructor para pasar la lista de elementos al widget
  const CustomCarousel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,  // Altura del carrusel
        autoPlay: true, // Reproducción automática
        enlargeCenterPage: false, // Agranda el elemento central
        enableInfiniteScroll: true, // Desliza infinitamente
      ),
      items: items.map((item) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(  // Añadir bordes redondeados a las imágenes
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item, // Cargar la imagen desde el path
              fit: BoxFit.cover, // Asegurar que la imagen cubra todo el espacio disponible
              width: double.infinity, // Asegura que la imagen ocupe todo el ancho del contenedor
            ),
          ),
        );
      }).toList(),
    );
  }
}
