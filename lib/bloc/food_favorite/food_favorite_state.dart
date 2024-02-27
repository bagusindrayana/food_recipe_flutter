part of 'food_favorite_bloc.dart';

abstract class FoodFavoriteState extends Equatable {
  const FoodFavoriteState();

  @override
  List<Object?> get props => [];
}

class FoodFavoriteInitial extends FoodFavoriteState {}

class FoodFavoriteLoading extends FoodFavoriteState {}

class FoodFavoriteLoadingMore extends FoodFavoriteState {
  final int page;

  const FoodFavoriteLoadingMore(this.page);

  @override
  List<Object?> get props => [page];
}

class FoodFavoriteLoaded extends FoodFavoriteState {
  final List<FoodFavorite> foodFavorites;
  final bool nextData;

  const FoodFavoriteLoaded(
      {required this.foodFavorites, required this.nextData});

  @override
  List<Object?> get props => [foodFavorites];
}

class FoodFavoriteError extends FoodFavoriteState {
  final String message;

  const FoodFavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
