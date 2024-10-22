class Promocion {
  final int? id;
  late final String title;
  late final String description;
  final int commerceId;

  Promocion({
    this.id,
    required this.title,
    required this.description,
    required this.commerceId,
  });

  // Método para convertir un mapa en un objeto Promocion
  factory Promocion.fromMap(Map<String, dynamic> map) {
    return Promocion(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      commerceId: map['commerceId'],
    );
  }

  // Método para convertir un objeto Promocion en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'commerceId': commerceId,
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
