import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:food_recipe/config/api_config.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:food_recipe/models/ingredient.dart';
import 'package:food_recipe/models/nutrition.dart';
import 'package:http/http.dart' as http;

class FoodListResponse {
  bool success;
  String message;
  List<FoodList> foodLists;
  String? nextPageUrl;
  Map<String, dynamic>? filters;

  FoodListResponse(
      {required this.success,
      required this.message,
      required this.foodLists,
      this.nextPageUrl,
      this.filters});
}

class FoodListRepository {
  final http.Client httpClient = http.Client();
  Future<FoodListResponse> getFoodList(
      String url, Map<String, dynamic>? filters) async {
    FoodListResponse foodListResponse =
        FoodListResponse(success: false, message: "", foodLists: []);
    Map<String, dynamic> queryParameters = {
      'app_id': ApiConfig.APP_ID,
      'app_key': ApiConfig.APP_KEY,
      'type': 'public',
    };
    Uri uri = Uri.parse(url);

    if (filters != null && filters.isNotEmpty) {
      queryParameters.addAll(filters);
      uri = uri.replace(queryParameters: queryParameters);
      print(uri.toString());
    }

    try {
      var response = await httpClient.get(uri);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = jsonData['hits'];

        final List<FoodList> FoodLists = data.map((foodList) {
          String image = foodList['recipe']['image'];

          if (foodList['recipe']['images'] != null &&
              foodList['recipe']['images']['LARGE'] != null) {
            image = foodList['recipe']['images']['LARGE']['url'];
          } else if (foodList['recipe']['images'] != null &&
              foodList['recipe']['images']['REGULER'] != null) {
            image = foodList['recipe']['images']['REGULER']['url'];
          }

          List<Nutrition> nutrisi = [];
          foodList['recipe']['totalNutrients'].forEach((k, v) => nutrisi.add(
              Nutrition(
                  id: k,
                  label: v['label'],
                  quantity: v['quantity'],
                  unit: v['unit'])));
          List<String> cT = [];
          if (foodList['recipe']['cuisineType'] != null) {
            cT = foodList['recipe']['cuisineType']
                .map<String>((e) => e.toString())
                .toList();
          }
          List<String> mT = [];
          if (foodList['recipe']['mealType'] != null) {
            mT = foodList['recipe']['mealType']
                .map<String>((e) => e.toString())
                .toList();
          }
          List<String> dT = [];
          if (foodList['recipe']['dishType'] != null) {
            dT = foodList['recipe']['dishType']
                .map<String>((e) => e.toString())
                .toList();
          }
          List<String> dL = [];
          if (foodList['recipe']['dietLabels'] != null) {
            dL = foodList['recipe']['dietLabels']
                .map<String>((e) => e.toString())
                .toList();
          }
          List<String> hL = [];
          if (foodList['recipe']['healthLabels'] != null) {
            hL = foodList['recipe']['healthLabels']
                .map<String>((e) => e.toString())
                .toList();
          }

          return FoodList(
              title: foodList['recipe']['label'],
              source: foodList['recipe']['source'],
              sourceUrl: foodList['recipe']['url'],
              img: foodList['recipe']['image'],
              link: foodList['_links']['self']['href'],
              thumb: foodList['recipe']['images']['THUMBNAIL']['url'],
              ingredients: foodList['recipe']['ingredients']
                  .map<Ingredient>((ingredient) => Ingredient(
                      text: ingredient['text'],
                      quantity: ingredient['quantity'],
                      measure: ingredient['measure'],
                      image: ingredient['image']))
                  .toList(),
              detailLink: foodList['_links']['self']['href'],
              calories: foodList['recipe']['calories'],
              cuisineType: cT,
              mealType: mT,
              dishType: dT,
              dietLabels: dL,
              healthLabels: hL,
              totalNutrients: nutrisi);
        }).toList();
        if (jsonData['_links']['next'] != null) {
          foodListResponse.nextPageUrl = jsonData['_links']['next']['href'];
        }
        foodListResponse.success = true;
        foodListResponse.foodLists = FoodLists;
        //yield FoodListLoaded(FoodLists);
      } else {
        foodListResponse.message = 'Failed to fetch FoodLists';
        //yield FoodListError('Failed to fetch FoodLists');
      }
    } catch (e, t) {
      if (kDebugMode) {
        print(e);
        print(t);
      }
      foodListResponse.message = 'Failed to fetch FoodLists';
    }
    return foodListResponse;
  }
}
