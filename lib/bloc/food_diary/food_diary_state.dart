part of 'food_diary_bloc.dart';

abstract class FoodDiaryState extends Equatable {
  const FoodDiaryState();

  @override
  List<Object?> get props => [];
}

class FoodDiaryInitial extends FoodDiaryState {}

class FoodDiaryLoading extends FoodDiaryState {}

class FoodDiaryLoadingMore extends FoodDiaryState {
  final int page;

  const FoodDiaryLoadingMore(this.page);

  @override
  List<Object?> get props => [page];
}

class FoodDiaryLoaded extends FoodDiaryState {
  final List<FoodDiary> foodDiaries;

  const FoodDiaryLoaded({required this.foodDiaries});

  @override
  List<Object?> get props => [foodDiaries];
}

class FoodDiaryError extends FoodDiaryState {
  final String message;

  const FoodDiaryError(this.message);

  @override
  List<Object?> get props => [message];
}
