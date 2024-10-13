import 'package:path/path.dart';
import 'package:promo_san_juan/models/carousel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Nombres de tablas
  final String tableComercios = 'comercios';
  final String tableDetalleComercios = 'detalle_comercios';
  final String tableCarousel = 'carousel';

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

  Future _onCreate(Database db, int version) async {
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
      horario TEXT
    )
  ''');

    await db.execute('''
      CREATE TABLE $tableCarousel(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagePath TEXT,
        title TEXT,
        subtitle TEXT,
        commerceId INTEGER
      )
    ''');

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

    await db.insert(tableComercios, {
      'name': 'Panadería Delicias',
      'imagePath': 'assets/comercios/panaderia_delicias.jpg',
      'descripcion': 'Panadería artesanal con productos horneados diariamente.',
    });

    await db.insert(tableComercios, {
      'name': 'Tienda Verde',
      'imagePath': 'assets/comercios/tienda_verde.jpg',
      'descripcion': 'Tienda de productos orgánicos y sostenibles.',
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
    });

    await db.insert(tableDetalleComercios, {
      'commerceId': 2,
      'name': 'Supermercado Central',
      'imagePath': 'assets/comercios/supermercado_central.jpg',
      'descripcion': 'Supermercado con productos frescos y de calidad.',
      'direccion': 'Avenida Siempre Viva 456',
      'telefono': '987-654-3210',
      'horario': '8:00 AM - 10:00 PM',
    });

    await db.insert(tableDetalleComercios, {
      'commerceId': 3,
      'name': 'Café Aromas',
      'imagePath': 'assets/comercios/cafe_aromas.jpg',
      'descripcion': 'Cafetería acogedora especializada en café gourmet.',
      'direccion': 'Plaza Central, Local 8',
      'telefono': '555-123-9876',
      'horario': '7:00 AM - 8:00 PM',
    });

    // Inserción de ítems del carrusel
    await db.insert(tableCarousel, {
      'imagePath': 'assets/carousel/frame_5.jpg',
      'title': 'Título 1',
      'subtitle': 'Subtítulo 1',
      'commerceId': 1,
    });

    await db.insert(tableCarousel, {
      'imagePath': 'assets/carousel/frame_6.jpg',
      'title': 'Título 2',
      'subtitle': 'Subtítulo 2',
      'commerceId': 2,
    });

    await db.insert(tableCarousel, {
      'imagePath': 'assets/carousel/frame_7.jpg',
      'title': 'Título 3',
      'subtitle': 'Subtítulo 3',
      'commerceId': 3,
    });
  }

  // Métodos para la tabla comercios
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
        'horario'
      ],
      where: 'commerceId = ?',
      whereArgs: [commerceId],
    );

    if (maps.isNotEmpty) {
      return ComercioDetalles(
        id: maps.first['id'] as int,
        commerceId: maps.first['commerceId'] as int,
        name: maps.first['name'] as String,
        imagePath: maps.first['imagePath'] as String,
        descripcion: maps.first['descripcion'] as String,
        direccion: maps.first['direccion'] as String,
        telefono: maps.first['telefono'] as String,
        horario: maps.first['horario'] as String,
      );
    } else {
      return null;
    }
  }

  // Métodos para la tabla carousel
  Future<List<CarouselItem>> getCarouselItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableCarousel);

    return List.generate(maps.length, (i) {
      return CarouselItem(
        imagePath: maps[i]['imagePath'],
        title: maps[i]['title'],
        subtitle: maps[i]['subtitle'],
        commerceId: maps[i]['commerceId'],
      );
    });
  }
}
