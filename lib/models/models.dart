class Promocion {
  final int? id;
  late final String title;
  late final String description;
  final int commerceId;
  bool activo;
  DateTime fechaInicio;
  DateTime fechaFin;

  Promocion({
    this.id,
    required this.title,
    required this.description,
    required this.commerceId,
    required this.activo,
    required this.fechaInicio,
    required this.fechaFin,
  });

  // Método para convertir un mapa en un objeto Promocion
  factory Promocion.fromMap(Map<String, dynamic> map) {
    return Promocion(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      commerceId: map['commerceId'],
      activo: map['activo'] == 1, // Asume que en la base de datos, 1 es true y 0 es false
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
    );
  }

  // Método para convertir un objeto Promocion en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'commerceId': commerceId,
      'activo': activo ? 1 : 0, // Convertimos a 1 o 0 para base de datos
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
    };
  }
}

class Comercio {
  final int id;
  final String name;
  final String imagePath;
  final String descripcion;

  Comercio(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.descripcion});
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
  final double lat;
  final double long;
  bool isHabilitado;

  ComercioDetalles(
      {required this.id,
      required this.commerceId,
      required this.name,
      required this.imagePath,
      required this.descripcion,
      required this.direccion,
      required this.telefono,
      required this.horario,
      required this.isHabilitado,
      required this.lat,
      required this.long});

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'commerceId': commerceId,
      'name': name,
      'imagePath': imagePath,
      'descripcion': descripcion,
      'direccion': direccion,
      'telefono': telefono,
      'horario': horario,
      'isHabilitado': isHabilitado ? 1 : 0,
      'lat': lat,
      'long': long
    };
  }

  // Método para crear una instancia a partir de un mapa
  factory ComercioDetalles.fromMap(Map<String, dynamic> map) {
    return ComercioDetalles(
      id: map['id'],
      commerceId: map['commerceId'],
      name: map['name'],
      imagePath: map['imagePath'],
      descripcion: map['descripcion'],
      direccion: map['direccion'],
      telefono: map['telefono'],
      horario: map['horario'],
      isHabilitado: map['isHabilitado'] == 1, // Convertir int a booleano
      lat: map['lat'],
      long: map['long']
    );
  }
}

class User {
  int? id;
  String email;
  String password;
  String role;

  User(
      {this.id,
      required this.email,
      required this.password,
      required this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}
