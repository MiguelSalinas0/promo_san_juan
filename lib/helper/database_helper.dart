import 'package:path/path.dart';
import 'package:promo_san_juan/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:latlong2/latlong.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Nombres de tablas
  final String tableComercios = 'comercios';
  final String tableDetalleComercios = 'detalle_comercios';
  final String tableUsuarios = 'usuarios';
  final String tablePromociones = 'promociones';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'promo_san_juan.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Obtener todas las promociones (vista de usuario)
  Future<List<Promocion>> getAllPromotions() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT p.*
    FROM $tablePromociones p
    INNER JOIN $tableDetalleComercios c ON p.commerceId = c.commerceId
    WHERE p.activo = 1 AND c.isHabilitado = 1
  ''');

    return result.map((promo) => Promocion.fromMap(promo)).toList();
  }

  // Obtener una promocion por id
  Future<Promocion?> getPromotionById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tablePromociones,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Promocion.fromMap(result.first);
    }
    return null;
  }

  // Obtener promociones por comercio (para la vista de comercio)
  Future<List<Promocion>> getPromotionsByCommerce(int commerceId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      tablePromociones,
      where: 'commerceId = ?',
      whereArgs: [commerceId],
    );
    return result.map((promo) => Promocion.fromMap(promo)).toList();
  }

  // Agregar nueva promoción
  Future<int> addPromotion(Promocion promotion) async {
    final db = await instance.database;
    return await db.insert(
      tablePromociones,
      promotion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Editar promoción existente
  Future<int> updatePromotion(Promocion promotion) async {
    final db = await instance.database;
    return await db.update(
      tablePromociones,
      promotion.toMap(),
      where: 'id = ? AND commerceId = ?',
      whereArgs: [promotion.id, promotion.commerceId],
    );
  }

  // Eliminar promoción
  Future<int> deletePromotion(int promotionId, int commerceId) async {
    final db = await instance.database;
    return await db.delete(
      tablePromociones,
      where: 'id = ? AND commerceId = ?',
      whereArgs: [promotionId, commerceId],
    );
  }

  // Login
  Future<User?> login(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      tableUsuarios,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Obtener datos de ubicacion de comercios (pantalla de mapa)
  Future<List<Map<String, dynamic>>> getLocations() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT name, descripcion, lat, long
    FROM $tableDetalleComercios
    WHERE isHabilitado = 1
  ''');

    // Convertir el resultado en una lista de Map en el formato requerido
    return result.map((map) {
      return {
        'name': map['name'],
        'location': LatLng(map['lat'], map['long']),
        'description': map['descripcion'],
      };
    }).toList();
  }

// Obtener datos de ubicación de un comercio por su ID
  Future<LatLng?> getLocationById(int idComercio) async {
    final db = await instance.database;

    final location = await db.query(
      tableDetalleComercios,
      columns: ['lat', 'long'],
      where: 'id = ?',
      whereArgs: [idComercio],
    );

    if (location.isNotEmpty) {
      final lat = location.first['lat'];
      final long = location.first['long'];

      return LatLng(
        (lat is int) ? lat.toDouble() : lat as double,
        (long is int) ? long.toDouble() : long as double,
      );
    } else {
      return null; // No se encontró un comercio con ese ID
    }
  }

  // Obtener todos los comercios (vista de admin, sin filtro de habilitación)
  Future<List<Comercio>> getComercios() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableComercios);

    return List.generate(maps.length, (i) {
      return Comercio(
          id: maps[i]['id'],
          name: maps[i]['name'],
          imagePath: maps[i]['imagePath'],
          descripcion: maps[i]['descripcion']);
    });
  }

  // Obtener todos los comercios habilitados (vista de usuario, con filtro de habilitación)
  Future<List<Comercio>> getComerciosUser() async {
    final db = await instance.database;

    // Consulta que une ambas tablas y filtra por comercios habilitados
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT c.id, c.name, c.imagePath, c.descripcion
    FROM $tableComercios AS c
    INNER JOIN $tableDetalleComercios AS d ON c.id = d.commerceId
    WHERE d.isHabilitado = 1
  ''');

    // Convertir los resultados en una lista de objetos Comercio
    return List.generate(maps.length, (i) {
      return Comercio(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imagePath: maps[i]['imagePath'],
        descripcion: maps[i]['descripcion'],
      );
    });
  }

  // Obtener comercio por id
  Future<Comercio?> getComercioById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableComercios,
      columns: ['id', 'name', 'imagePath', 'descripcion'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Comercio(
        id: maps.first['id'] as int,
        name: maps.first['name'] as String,
        imagePath: maps.first['imagePath'] as String,
        descripcion: maps.first['descripcion'] as String,
      );
    } else {
      return null;
    }
  }

  // Obtener los detalles de un comercio
  Future<ComercioDetalles?> getComercioDetallesById(int commerceId) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDetalleComercios,
      columns: [
        'id',
        'commerceId',
        'name',
        'imagePath',
        'descripcion',
        'direccion',
        'telefono',
        'horario',
        'isHabilitado',
        'lat',
        'long'
      ],
      where: 'commerceId = ?',
      whereArgs: [commerceId],
    );

    if (maps.isNotEmpty) {
      return ComercioDetalles.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Obtener si el comercio esta habilitado (vista del comercio)
  Future<bool> consultarHabilitacion(int commerceId) async {
    final db = await instance.database;

    final result = await db.query(
      tableDetalleComercios,
      columns: ['isHabilitado'],
      where: 'commerceId = ?',
      whereArgs: [commerceId],
    );

    if (result.isNotEmpty) {
      return result.first['isHabilitado'] == 1;
    } else {
      return false;
    }
  }

  // Update habilitación
  Future<ComercioDetalles?> updateComercioHabilitacion(
      int commerceId, bool value) async {
    final db = await instance.database;

    int habilitadoValue = value ? 1 : 0;
    await db.update(
      tableDetalleComercios,
      {'isHabilitado': habilitadoValue},
      where: 'id = ?',
      whereArgs: [commerceId],
    );

    return getComercioDetallesById(commerceId);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePromociones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      commerceId INTEGER,
      activo INTEGER NOT NULL, 
      fechaInicio TEXT NOT NULL,
      fechaFin TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableUsuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableComercios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imagePath TEXT,
        descripcion TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE $tableDetalleComercios(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      commerceId INTEGER,
      name TEXT,
      imagePath TEXT,
      descripcion TEXT,
      direccion TEXT,
      telefono TEXT,
      horario TEXT,
      isHabilitado INTEGER NOT NULL,
      lat REAL,
      long REAL
    )
  ''');

    // Insertar datos de promociones
    await db.insert(tablePromociones, {
      'title': 'Descuento 2x1',
      'description': '2x1 en todos los articulos seleccionados',
      'commerceId': 2,
      'activo': 1,
      'fechaInicio': DateTime(2024, 11, 1).toIso8601String(),
      'fechaFin': DateTime(2024, 12, 1).toIso8601String(),
    });

    await db.insert(tablePromociones, {
      'title': '2x1 en Auriculares',
      'description': 'Lleva 2 por el precio de 1 en auriculares',
      'commerceId': 2,
      'activo': 1,
      'fechaInicio': DateTime(2024, 11, 5).toIso8601String(),
      'fechaFin': DateTime(2024, 11, 30).toIso8601String(),
    });

    await db.insert(tablePromociones, {
      'title': 'Descuento 10%',
      'description': '10% de descuento en productos seleccionados',
      'commerceId': 3,
      'activo': 1,
      'fechaInicio': DateTime(2024, 10, 1).toIso8601String(),
      'fechaFin': DateTime(2024, 10, 31).toIso8601String(),
    });

    // Insertar datos de usuarios
    await db.insert(tableUsuarios, {
      'email': 'usuario@gmail.com',
      'password': '12345',
      'role': 'usuario',
    });

    await db.insert(tableUsuarios, {
      'email': 'comercio@gmail.com',
      'password': '12345',
      'role': 'comercio',
    });

    await db.insert(tableUsuarios, {
      'email': 'comercio2@gmail.com',
      'password': '12345',
      'role': 'comercio',
    });

    await db.insert(tableUsuarios, {
      'email': 'admin@gmail.com',
      'password': '12345',
      'role': 'admin',
    });

    // Insertar datos iniciales (solo la primera vez)
    await db.insert(tableComercios, {
      'name': 'La Buena Mesa',
      'imagePath': 'assets/comercios/la_buena_mesa.jpg',
      'descripcion': 'Restaurante de cocina tradicional con un toque moderno.',
    });

    await db.insert(tableComercios, {
      'name': 'Supermercado Central',
      'imagePath': 'assets/comercios/supermercado_central.jpg',
      'descripcion': 'Supermercado con productos frescos y de calidad.',
    });

    await db.insert(tableComercios, {
      'name': 'Café Aromas',
      'imagePath': 'assets/comercios/cafe_aromas.jpg',
      'descripcion': 'Cafetería acogedora especializada en café gourmet.',
    });

    // Inserción de detalles de comercios
    await db.insert(tableDetalleComercios, {
      'commerceId': 1,
      'name': 'La Buena Mesa',
      'imagePath': 'assets/comercios/la_buena_mesa.jpg',
      'descripcion': 'Restaurante de cocina tradicional con un toque moderno.',
      'direccion': 'Calle Falsa 123',
      'telefono': '123-456-7890',
      'horario': '9:00 AM - 11:00 PM',
      'isHabilitado': 1,
      'lat': -31.551255327323908,
      'long': -68.54143522853005
    });

    await db.insert(tableDetalleComercios, {
      'commerceId': 2,
      'name': 'Supermercado Central',
      'imagePath': 'assets/comercios/supermercado_central.jpg',
      'descripcion': 'Supermercado con productos frescos y de calidad.',
      'direccion': 'Avenida Siempre Viva 456',
      'telefono': '987-654-3210',
      'horario': '8:00 AM - 10:00 PM',
      'isHabilitado': 1,
      'lat': -31.533,
      'long': -68.537
    });

    await db.insert(tableDetalleComercios, {
      'commerceId': 3,
      'name': 'Café Aromas',
      'imagePath': 'assets/comercios/cafe_aromas.jpg',
      'descripcion': 'Cafetería acogedora especializada en café gourmet.',
      'direccion': 'Plaza Central, Local 8',
      'telefono': '555-123-9876',
      'horario': '7:00 AM - 8:00 PM',
      'isHabilitado': 1,
      'lat': -31.52853125160821,
      'long': -68.53709612809254
    });
  }
}
