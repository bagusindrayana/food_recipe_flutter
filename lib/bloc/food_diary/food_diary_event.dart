part of 'food_diary_bloc.dart';

abstract class FoodDiaryEvent extends Equatable {
  const FoodDiaryEvent();

  @override
  List<Object?> get props => [];
}

class FetchFoodDiaries extends FoodDiaryEvent {
  final String query;

  const FetchFoodDiaries({required this.query}) : super();

  @override
  List<Object> get props => [query];
}

class LoadMoreFoodDiaries extends FoodDiaryEvent {
  const LoadMoreFoodDiaries() : super();
}
