import 'package:food_recipe/models/food_diary.dart';
import 'package:sqflite/sqflite.dart';

//FoodDiaryFields
class FoodDiaryFields {
  static final String id = 'id';
  static final String url = 'url';
  static final String label = 'label';
  static final String quantity = 'quantity';
  static final String calories = 'calories';
  static final String dateTime = 'dateTime';

  static final List<String> values = [
    id,
    url,
    label,
    quantity,
    calories,
    dateTime,
  ];
}

class MyDB {
  static final MyDB instance = MyDB._init();

  static Database? _database;

  MyDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mydb.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(filePath, version: 1, onCreate: _createTable);
  }

  Future _createTable(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final realType = 'REAL NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final tableFoodDiary = 'food_diary';

    await db.execute('''CREATE TABLE $tableFoodDiary ( 
      ${FoodDiaryFields.id} $idType, 
      ${FoodDiaryFields.url} $textType,
      ${FoodDiaryFields.label} $textType,
      ${FoodDiaryFields.quantity} $realType,
      ${FoodDiaryFields.calories} $realType,
      ${FoodDiaryFields.dateTime} $textType
      )''');
  }
}
