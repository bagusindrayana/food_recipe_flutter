import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_recipe/models/food_favorite.dart';
import 'package:food_recipe/repositories/food_favorite_repository.dart';

part 'food_favorite_event.dart';
part 'food_favorite_state.dart';

class FoodFavoriteBloc extends Bloc<FoodFavoriteEvent, FoodFavoriteState> {
  final int limit;
  int page = 1;
  String query = '';
  List<FoodFavorite> datas = [];

  FoodFavoriteBloc({required this.limit}) : super(FoodFavoriteInitial()) {
    on<DeleteFoodFavorite>(deleteData);
    on<FetchFoodFavorites>(fetchData);
    on<LoadMoreFoodFavorites>(loadMoreData);
  }

  fetchData(FetchFoodFavorites event, Emitter<FoodFavoriteState> emit) async {
    page = 1;
    query = event.query;
    emit(FoodFavoriteLoading());
    datas = [];
    await loadData(emit);
  }

  loadMoreData(
      LoadMoreFoodFavorites event, Emitter<FoodFavoriteState> emit) async {
    page += 1;
    emit(FoodFavoriteLoadingMore(page));
    await loadData(emit);
  }

  loadData(Emitter<FoodFavoriteState> emit) async {
    int offset = (page - 1) * limit;

    try {
      FoodFavoriteRepository foodDiaryRepository = FoodFavoriteRepository();
      DateTime now = DateTime.now();
      final List<FoodFavorite> foodFavorites = await foodDiaryRepository
          .listFoodDate(now, limit, offset, search: query);
      datas.addAll(foodFavorites);
      await Future.delayed(const Duration(seconds: 1), () {
        if (datas.isEmpty) {
          emit(FoodFavoriteError("No data found"));
        } else {
          bool nextData = foodFavorites.length < limit ? false : true;
          emit(FoodFavoriteLoaded(foodFavorites: datas, nextData: nextData));
        }
      });
    } catch (e) {
      emit(FoodFavoriteError(e.toString()));
    }
  }

  deleteData(DeleteFoodFavorite event, Emitter<FoodFavoriteState> emit) async {
    int id = event.id;
    try {
      FoodFavoriteRepository foodDiaryRepository = FoodFavoriteRepository();
      await foodDiaryRepository.delete(id);
      datas.removeWhere((element) => element.id == id);
      emit(FoodFavoriteLoading());
      await Future.delayed(const Duration(milliseconds: 500), () {
        print("Delete Block : " + datas.length.toString());
        emit(FoodFavoriteLoaded(foodFavorites: datas, nextData: false));
      });
    } catch (e) {
      emit(FoodFavoriteError(e.toString()));
    }
  }
}
