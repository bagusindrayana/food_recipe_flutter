import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_list/food_list_event.dart';
import 'package:food_recipe/bloc/food_list/food_list_state.dart';
import 'package:food_recipe/config/api_config.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:food_recipe/models/ingredient.dart';
import 'package:food_recipe/models/nutrition.dart';
import 'package:food_recipe/repositories/food_list_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class FoodListBloc extends Bloc<FoodListEvent, FoodListState> {
  final FoodListRepository foodListRepository = FoodListRepository();
  String? nextPageUrl;

  FoodListBloc({this.nextPageUrl}) : super(FoodListInitial()) {
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

      Map<String, dynamic> queryParameters = {
        // 'app_id': ApiConfig.APP_ID,
        // 'app_key': ApiConfig.APP_KEY,
        // 'type': 'public',
        'q': query
      };

      if (event is FetchFoodLists) {
        if (event.mealType != null) {
          queryParameters.addAll({'mealType': event.mealType});
        }

        if (event.dishType != null) {
          queryParameters.addAll({'dishType': event.dishType});
        }

        if (event.diet != null) {
          queryParameters.addAll({'diet': event.diet});
        }
      }

      if (kDebugMode) {
        print(queryParameters);
      }
      if (nextPageUrl != null) {
        queryParameters = {};
      }
      String url = nextPageUrl != null
          ? nextPageUrl!
          : Uri.https('api.edamam.com', '/api/recipes/v2').toString();
      print(url.toString());
      await foodListRepository.getFoodList(url, queryParameters).then((r) {
        if (r.success) {
          if (r.nextPageUrl != null) {
            nextPageUrl = r.nextPageUrl;
          }

          emit(FoodListLoaded(r.foodLists));
        } else {
          emit(FoodListError(r.message));
        }
      });
    } catch (e, t) {
      if (kDebugMode) {
        print(e);
        print(t);
      }
      emit(FoodListError('Failed to fetch FoodLists'));
      //yield FoodListError('Failed to fetch FoodLists');
    }
  }
}
