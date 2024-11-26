import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // Veritabanı dosyasını bulmak için

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Veritabanı bağlantısı
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Veritabanı yoksa oluştur
    _database = await _initDB('user_database.db');
    return _database!;
  }

  // Veritabanı dosyasını başlatma
  Future<Database> _initDB(String filePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    // Veritabanını aç veya oluştur
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Tabloyu oluşturma
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Yeni kullanıcı ekleme
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  // E-posta ve şifreyle kullanıcıyı sorgulama
  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
