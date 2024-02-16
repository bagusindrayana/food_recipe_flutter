part of 'food_diary_bloc.dart';

abstract class FoodDiaryEvent extends Equatable {
  const FoodDiaryEvent();

  @override
  List<Object?> get props => [];
}

class FetchFoodDiaries extends FoodDiaryEvent {
  final String query;
  final int page;
  const FetchFoodDiaries({required this.query, required this.page}) : super();

  @override
  List<Object> get props => [query, page];
}

class LoadMoreFoodDiaries extends FoodDiaryEvent {
  const LoadMoreFoodDiaries() : super();
}
