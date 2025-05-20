import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/gallon_model.dart';
import '../models/request_modal.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'refillmate.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        profile_photo_path TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE gallons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        image_path TEXT,
        description TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        datetime TEXT,
        status TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE request_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        request_id INTEGER,
        gallon_id INTEGER,
        quantity INTEGER
      )
    ''');
    await seedGallons(db);
    await seedDemoData(db);
  }

  Future<void> seedGallons(Database db) async {
    final gallons = [
      Gallon(
        name: 'Standard Jug Gallon',
        price: 25.0,
        imagePath: 'assets/images/jug-gallon.png',
        description: 'Standard 5-gallon water jug, common for refilling in the Philippines.'
      ),
      Gallon(
        name: 'Water Container',
        price: 25.0,
        imagePath: 'assets/images/water-container.png',
        description: 'Durable water container, suitable for household and commercial use.'
      ),
    ];
    for (final g in gallons) {
      await db.insert('gallons', g.toMap());
    }
  }

  // Seed demo user and sample request if users table is empty
  Future<void> seedDemoData(Database db) async {
    final userCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users')) ?? 0;
    if (userCount == 0) {
      // Insert admin user
      final admin = User(
        name: 'Admin User',
        email: 'admin@email.com',
        password: User.hashPassword('admin123'),
      );
      final adminId = await db.insert('users', admin.toMap());
      // Insert demo user
      final user = User(
        name: 'Juan Dela Cruz',
        email: 'juan@email.com',
        password: User.hashPassword('password123'),
      );
      final userId = await db.insert('users', user.toMap());
      // Get gallons
      final gallons = await db.query('gallons');
      // Create a request for admin
      final now = DateTime.now().toIso8601String();
      final adminRequestId = await db.insert('requests', {
        'user_id': adminId,
        'datetime': now,
        'status': 'pending',
      });
      for (final g in gallons) {
        await db.insert('request_items', {
          'request_id': adminRequestId,
          'gallon_id': g['id'],
          'quantity': 2,
        });
      }
      // Create a request for demo user
      final userRequestId = await db.insert('requests', {
        'user_id': userId,
        'datetime': now,
        'status': 'pending',
      });
      for (final g in gallons) {
        await db.insert('request_items', {
          'request_id': userRequestId,
          'gallon_id': g['id'],
          'quantity': 1,
        });
      }
    }
  }

  // USER CRUD
  Future<int> insertUser(User user) async {
    final database = await db;
    return await database.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final database = await db;
    final result = await database.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final database = await db;
    final result = await database.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final database = await db;
    return await database.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // GALLON CRUD
  Future<List<Gallon>> getGallons() async {
    final database = await db;
    final result = await database.query('gallons');
    return result.map((e) => Gallon.fromMap(e)).toList();
  }

  // REQUEST CRUD
  Future<int> insertRequest(Request request) async {
    final database = await db;
    return await database.insert('requests', request.toMap());
  }
  Future<int> insertRequestItem(RequestItem item) async {
    final database = await db;
    return await database.insert('request_items', item.toMap());
  }
  Future<List<Request>> getRequestsByUser(int userId) async {
    final database = await db;
    final result = await database.query('requests', where: 'user_id = ?', whereArgs: [userId], orderBy: 'datetime DESC');
    return result.map((e) => Request.fromMap(e)).toList();
  }
  Future<List<RequestItem>> getRequestItems(int requestId) async {
    final database = await db;
    final result = await database.query('request_items', where: 'request_id = ?', whereArgs: [requestId]);
    return result.map((e) => RequestItem.fromMap(e)).toList();
  }
  Future<int> updateRequest(Request request) async {
    final database = await db;
    return await database.update('requests', request.toMap(), where: 'id = ?', whereArgs: [request.id]);
  }
  Future<int> deleteRequest(int requestId) async {
    final database = await db;
    await database.delete('request_items', where: 'request_id = ?', whereArgs: [requestId]);
    return await database.delete('requests', where: 'id = ?', whereArgs: [requestId]);
  }
  Future<int> deleteRequestItem(int itemId) async {
    final database = await db;
    return await database.delete('request_items', where: 'id = ?', whereArgs: [itemId]);
  }
}
