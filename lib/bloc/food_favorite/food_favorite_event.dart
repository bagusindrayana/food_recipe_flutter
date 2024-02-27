part of 'food_favorite_bloc.dart';

abstract class FoodFavoriteEvent extends Equatable {
  const FoodFavoriteEvent();

  @override
  List<Object?> get props => [];
}

class FetchFoodFavorites extends FoodFavoriteEvent {
  final String query;
  const FetchFoodFavorites({required this.query}) : super();

  @override
  List<Object> get props => [query];
}

class DeleteFoodFavorite extends FoodFavoriteEvent {
  final int id;
  const DeleteFoodFavorite({required this.id}) : super();

  @override
  List<Object> get props => [id];
}

class LoadMoreFoodFavorites extends FoodFavoriteEvent {
  const LoadMoreFoodFavorites() : super();
}
