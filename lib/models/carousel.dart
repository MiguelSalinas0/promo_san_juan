class CarouselItem {
  final String imagePath;
  final String title;
  final String subtitle;
  final int commerceId;

  CarouselItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.commerceId,
  });
}

class Comercio {
  final int id;
  final String name;
  final String imagePath;
  final String descripcion;

  Comercio({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.descripcion
  });
}

class ComercioDetalles {
  final int id;
  final int commerceId;
  final String name;
  final String imagePath;
  final String descripcion;
  final String direccion;
  final String telefono;
  final String horario;

  ComercioDetalles({
    required this.id,
    required this.commerceId,
    required this.name,
    required this.imagePath,
    required this.descripcion,
    required this.direccion,
    required this.telefono,
    required this.horario,
  });
}
