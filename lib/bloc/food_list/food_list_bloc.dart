import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_list/food_list_event.dart';
import 'package:food_recipe/bloc/food_list/food_list_state.dart';
import 'package:food_recipe/config/api_config.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:food_recipe/models/ingredient.dart';
import 'package:food_recipe/models/nutrition.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class FoodListBloc extends Bloc<FoodListEvent, FoodListState> {
  final http.Client httpClient;
  String? nextPageUrl;

  FoodListBloc({required this.httpClient, this.nextPageUrl})
      : super(FoodListInitial()) {
    on<FetchFoodLists>(mapEventToState);
  }

  // FoodListBloc(this.httpClient) : super(FoodListInitial()) {
  //   on<FetchFoodLists>(mapEventToState);
  // }

  mapEventToState(FoodListEvent event, Emitter<FoodListState> emit) async {
    if (nextPageUrl == null) {
      emit(FoodListLoading());
    } else {
      emit(FoodListLoadingMore());
    }

    try {
      // final List<Locale> systemLocales =
      //     WidgetsBinding.instance.platformDispatcher.locales;
      // print(systemLocales.first.languageCode);
      // final query = await UtilityHelper().translate(event.query,"" "en");
      // print(query);
      var query = event.query;
      // if (systemLocales.isNotEmpty) {
      //   query = await UtilityHelper().translate(
      //       event.query, systemLocales.first.languageCode, "en");
      // }

      final queryParameters = {
        'app_id': ApiConfig.APP_ID,
        'app_key': ApiConfig.APP_KEY,
        'type': 'public',
        'q': query
      };
      if (kDebugMode) {
        print(queryParameters);
      }
      Uri uri = nextPageUrl != null
          ? Uri.parse(nextPageUrl!)
          : Uri.https('api.edamam.com', '/api/recipes/v2', queryParameters);
      var response = await httpClient.get(uri);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = jsonData['hits'];

        final List<FoodList> FoodLists = data.map((foodList) {
          List<Nutrition> nutrisi = [];
          foodList['recipe']['totalNutrients'].forEach((k, v) => nutrisi.add(
              Nutrition(
                  id: k,
                  label: v['label'],
                  quantity: v['quantity'],
                  unit: v['unit'])));
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
              cuisineType: foodList['recipe']['cuisineType'].cast<String>(),
              mealType: foodList['recipe']['mealType'].cast<String>(),
              dishType: foodList['recipe']['dishType'].cast<String>(),
              dietLabels: foodList['recipe']['dietLabels'].cast<String>(),
              healthLabels: foodList['recipe']['healthLabels'].cast<String>(),
              totalNutrients: nutrisi);
        }).toList();
        if (jsonData['_links']['next'] != null) {
          nextPageUrl = jsonData['_links']['next']['href'];
        }

        emit(FoodListLoaded(FoodLists));
        //yield FoodListLoaded(FoodLists);
      } else {
        emit(FoodListError('Failed to fetch FoodLists'));
        //yield FoodListError('Failed to fetch FoodLists');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(FoodListError('Failed to fetch FoodLists'));
      //yield FoodListError('Failed to fetch FoodLists');
    }
  }
}
