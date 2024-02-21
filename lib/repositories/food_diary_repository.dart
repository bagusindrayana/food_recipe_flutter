import 'package:food_recipe/models/food_diary.dart';
import 'package:food_recipe/utility/database.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class FoodDiaryRepository {
  //get list
  Future<List<FoodDiary>> readAllFoodDiary() async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query('food_diary');

    return result.map((json) => FoodDiary.fromJson(json)).toList();
  }

  Future<FoodDiary> create(FoodDiary foodDiary) async {
    final Database _database = await MyDB.instance.database;
    final id = await _database.insert('food_diary', foodDiary.toJson());
    return foodDiary.copy(id: id);
  }

  Future<FoodDiary> readFoodDiary(int id) async {
    final Database _database = await MyDB.instance.database;
    final maps = await _database.query(
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
    final Database _database = await MyDB.instance.database;
    return _database.update(
      'food_diary',
      foodDiary.toJson(),
      where: '${FoodDiaryFields.id} = ?',
      whereArgs: [foodDiary.id],
    );
  }

  Future<int> delete(int id) async {
    final Database _database = await MyDB.instance.database;
    return await _database.delete(
      'food_diary',
      where: '${FoodDiaryFields.id} = ?',
      whereArgs: [id],
    );
  }

  //list with paginate and search
  Future<List<FoodDiary>> readAllFoodDiaryPaginate(int limit, int offset,
      {String? search}) async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query(
      'food_diary',
      limit: limit,
      offset: offset,
      where: search == null ? null : '${FoodDiaryFields.label} LIKE ?',
      whereArgs: search == null ? null : ['%$search%'],
      orderBy: '${FoodDiaryFields.dateTime} DESC',
    );

    return result.map((json) => FoodDiary.fromJson(json)).toList();
  }

  //
  Future<List<FoodDiary>> listFoodDate(DateTime now, int limit, int offset,
      {String? search}) async {
    final Database _database = await MyDB.instance.database;
    String s = search == null ? '' : search;
    final result = await _database.query(
      'food_diary',
      limit: limit,
      offset: offset,
      where:
          'date(${FoodDiaryFields.dateTime}) LIKE ? AND ${FoodDiaryFields.label} LIKE ?',
      whereArgs: ['%${DateFormat('yyyy-MM-dd').format(now)}%', '%$s%'],
      orderBy: '${FoodDiaryFields.dateTime} DESC',
    );
    return result.map((json) => FoodDiary.fromJson(json)).toList();
  }

  //list where date between
  Future<List<FoodDiary>> readAllFoodDiaryWhereDateBetween(
      DateTime startDate, DateTime endDate) async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query(
      'food_diary',
      where: '${FoodDiaryFields.dateTime} BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return result.map((json) => FoodDiary.fromJson(json)).toList();
  }

  //list where date, sum calories and group by date
  Future<Map<String, dynamic>> sumCaloriesInDate(DateTime date) async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.rawQuery(
        'SELECT SUM(${FoodDiaryFields.calories}) as calories FROM food_diary WHERE date(${FoodDiaryFields.dateTime}) = ?',
        [DateFormat('yyyy-MM-dd').format(date)]);
    return result.first;
  }

  Future<double> sumCalories() async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.rawQuery(
        'SELECT SUM(${FoodDiaryFields.calories}) as calories FROM food_diary');
    return ((result.first['calories'] ?? 0) as num).toDouble();
  }

  //find one data buy url
  Future<FoodDiary?> readFoodDiaryByUrl(String url) async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query(
      'food_diary',
      where: '${FoodDiaryFields.url} = ?',
      whereArgs: [url],
    );

    if (result.isNotEmpty) {
      return FoodDiary.fromJson(result.first);
    } else {
      return null;
    }
  }
}
