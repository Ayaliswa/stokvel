import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class LoginDatabaseHelper {
  static const databaseName = "Stokvel.db";
  static const databaseVersion = 1;

  static const table = 'Login';

  static const columnId = 'id';
  static const columnUsername = 'username';
  static const columnPhone = 'phone';
  static const columnPassword = 'password';
  static const columnGender = 'gender';

  LoginDatabaseHelper._privateConstructor();
  static final LoginDatabaseHelper instance =
      LoginDatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  _initDatabase() async {
    try {
      print('_initDatabase function called');
      String path = join(await getDatabasesPath(), databaseName);
      return await openDatabase(path,
          version: databaseVersion, onCreate: _onCreate);
    } catch (e) {
      print('Exception in _initDatabase: $e');
      return null;
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUsername TEXT NOT NULL,
            $columnPhone TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnGender TEXT NOT NULL
          )
          ''');
  }

  Future<int> saveUser(User user) async {
    try {
      print('saveUser function called');
      Database db = await instance.database;
      var res = await db.insert(table, user.toMap());
      print('User saved: $res');
      return res;
    } catch (e) {
      print('Exception in saveUser: $e');
      return -1;
    }
  }
}

class User {
  int? id;
  String username;
  String phone;
  String password;
  String gender;

  User(this.username, this.phone, this.password, this.gender, {this.id});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      LoginDatabaseHelper.columnUsername: username,
      LoginDatabaseHelper.columnPhone: phone,
      LoginDatabaseHelper.columnPassword: password,
      LoginDatabaseHelper.columnGender: gender,
    };
    if (id != null) {
      map[LoginDatabaseHelper.columnId] = id;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map[LoginDatabaseHelper.columnId],
        username = map[LoginDatabaseHelper.columnUsername],
        phone = map[LoginDatabaseHelper.columnPhone],
        password = map[LoginDatabaseHelper.columnPassword],
        gender = map[LoginDatabaseHelper.columnGender];
}
