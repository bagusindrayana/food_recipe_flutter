import 'package:food_recipe/models/food_diary.dart';
import 'package:food_recipe/utility/database.dart';
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
}
