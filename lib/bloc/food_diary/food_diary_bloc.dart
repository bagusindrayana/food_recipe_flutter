import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_recipe/models/food_diary.dart';
import 'package:food_recipe/repositories/food_diary_repository.dart';
import 'package:food_recipe/utility/database.dart';
import 'package:sqflite/sqflite.dart';

part 'food_diary_event.dart';
part 'food_diary_state.dart';

class FoodDiaryBloc extends Bloc<FoodDiaryEvent, FoodDiaryState> {
  final int limit;
  int page = 1;
  String query = '';
  List<FoodDiary> datas = [];

  FoodDiaryBloc({required this.limit}) : super(FoodDiaryInitial()) {
    on<FetchFoodDiaries>(mapEventToState);
    on<LoadMoreFoodDiaries>(mapEventToState);
  }

  mapEventToState(FoodDiaryEvent event, Emitter<FoodDiaryState> emit) async {
    if (event is FetchFoodDiaries) {
      datas = [];
      query = event.query;
      page = 1;
      emit(FoodDiaryLoading());
    }
    if (event is LoadMoreFoodDiaries) {
      page += 1;
      emit(FoodDiaryLoadingMore(page));
    }
    int offset = (page - 1) * limit;

    try {
      FoodDiaryRepository foodDiaryRepository = FoodDiaryRepository();
      DateTime now = DateTime.now();
      final List<FoodDiary> foodDiaries = await foodDiaryRepository
          .listFoodDate(now, limit, offset, search: query);
      await Future.delayed(const Duration(seconds: 1), () {
        datas.addAll(foodDiaries);
        if (foodDiaries.isEmpty) {
          emit(FoodDiaryError("No data found"));
        } else {
          bool nextData = foodDiaries.length < limit ? false : true;
          emit(FoodDiaryLoaded(foodDiaries: foodDiaries));
        }
      });
    } catch (e) {
      emit(FoodDiaryError(e.toString()));
    }
  }
}
