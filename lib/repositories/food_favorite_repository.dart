import 'package:food_recipe/models/food_favorite.dart';
import 'package:food_recipe/utility/database.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class FoodFavoriteRepository {
  //get list
  Future<List<FoodFavorite>> readAllFoodFavorite() async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query('food_favorite');

    return result.map((json) => FoodFavorite.fromJson(json)).toList();
  }

  Future<FoodFavorite> create(FoodFavorite foodDiary) async {
    final Database _database = await MyDB.instance.database;
    final id = await _database.insert('food_favorite', foodDiary.toJson());
    return foodDiary.copy(id: id);
  }

  Future<FoodFavorite> readFoodFavorite(int id) async {
    final Database _database = await MyDB.instance.database;
    final maps = await _database.query(
      'food_favorite',
      columns: FoodFavoriteFields.values,
      where: '${FoodFavoriteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FoodFavorite.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> update(FoodFavorite foodDiary) async {
    final Database _database = await MyDB.instance.database;
    return _database.update(
      'food_favorite',
      foodDiary.toJson(),
      where: '${FoodFavoriteFields.id} = ?',
      whereArgs: [foodDiary.id],
    );
  }

  Future<int> delete(int id) async {
    final Database _database = await MyDB.instance.database;
    return await _database.delete(
      'food_favorite',
      where: '${FoodFavoriteFields.id} = ?',
      whereArgs: [id],
    );
  }

  //list with paginate and search
  Future<List<FoodFavorite>> readAllFoodFavoritePaginate(int limit, int offset,
      {String? search}) async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query(
      'food_favorite',
      limit: limit,
      offset: offset,
      where: search == null ? null : '${FoodFavoriteFields.label} LIKE ?',
      whereArgs: search == null ? null : ['%$search%'],
      orderBy: '${FoodFavoriteFields.dateTime} DESC',
    );

    return result.map((json) => FoodFavorite.fromJson(json)).toList();
  }

  //
  Future<List<FoodFavorite>> listFoodDate(DateTime now, int limit, int offset,
      {String? search}) async {
    final Database _database = await MyDB.instance.database;
    String s = search == null ? '' : search;
    final result = await _database.query(
      'food_favorite',
      limit: limit,
      offset: offset,
      where:
          'date(${FoodFavoriteFields.dateTime}) LIKE ? AND ${FoodFavoriteFields.label} LIKE ?',
      whereArgs: ['%${DateFormat('yyyy-MM-dd').format(now)}%', '%$s%'],
      orderBy: '${FoodFavoriteFields.dateTime} DESC',
    );
    return result.map((json) => FoodFavorite.fromJson(json)).toList();
  }

  //list where date between
  Future<List<FoodFavorite>> readAllFoodFavoriteWhereDateBetween(
      DateTime startDate, DateTime endDate) async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query(
      'food_favorite',
      where: '${FoodFavoriteFields.dateTime} BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return result.map((json) => FoodFavorite.fromJson(json)).toList();
  }

  //find one data buy url
  Future<FoodFavorite?> readFoodFavoriteByUrl(String url) async {
    final Database _database = await MyDB.instance.database;
    final result = await _database.query(
      'food_favorite',
      where: '${FoodFavoriteFields.url} = ?',
      whereArgs: [url],
    );

    if (result.isNotEmpty) {
      return FoodFavorite.fromJson(result.first);
    } else {
      return null;
    }
  }
}
