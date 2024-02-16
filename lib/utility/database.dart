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

  //get list
  Future<List<FoodDiary>> readAllFoodDiary() async {
    final db = await instance.database;

    final result = await db.query('food_diary');

    return result.map((json) => FoodDiary.fromJson(json)).toList();
  }

  Future<FoodDiary> create(FoodDiary foodDiary) async {
    final db = await instance.database;
    final id = await db.insert('food_diary', foodDiary.toJson());
    return foodDiary.copy(id: id);
  }

  Future<FoodDiary> readFoodDiary(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'food_diary',
      columns: FoodDiaryFields.values,
      where: '${FoodDiaryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FoodDiary.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> update(FoodDiary foodDiary) async {
    final db = await instance.database;

    return db.update(
      'food_diary',
      foodDiary.toJson(),
      where: '${FoodDiaryFields.id} = ?',
      whereArgs: [foodDiary.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'food_diary',
      where: '${FoodDiaryFields.id} = ?',
      whereArgs: [id],
    );
  }

  //list with paginate and search
  Future<List<FoodDiary>> readAllFoodDiaryPaginate(int limit, int offset,
      {String? search}) async {
    final db = await instance.database;

    final result = await db.query(
      'food_diary',
      limit: limit,
      offset: offset,
      where: search == null ? null : '${FoodDiaryFields.label} LIKE ?',
      whereArgs: search == null ? null : ['%$search%'],
    );

    return result.map((json) => FoodDiary.fromJson(json)).toList();
  }
}
