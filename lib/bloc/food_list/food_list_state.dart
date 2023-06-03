import 'package:equatable/equatable.dart';
import 'package:food_recipe/models/food_list.dart';

abstract class FoodListState extends Equatable {
  const FoodListState();

  @override
  List<Object?> get props => [];
}

class FoodListInitial extends FoodListState {}

class FoodListLoading extends FoodListState {}

class FoodListLoadingMore extends FoodListState {}

class FoodListLoaded extends FoodListState {
  final List<FoodList> foodLists;

  const FoodListLoaded(this.foodLists);

  @override
  List<Object?> get props => [foodLists];
}

class FoodListError extends FoodListState {
  final String message;

  const FoodListError(this.message);

  @override
  List<Object?> get props => [message];
}
