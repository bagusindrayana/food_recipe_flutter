// Event class for the BLoC
import 'package:equatable/equatable.dart';

abstract class FoodListEvent extends Equatable {
  final String query;
  const FoodListEvent({required this.query});

  @override
  List<Object?> get props => [];
}

class FetchFoodLists extends FoodListEvent {
  final String query;
  List<String>? mealType;
  List<String>? diet;
  List<String>? health;
  List<String>? dishType;
  double? minCalories;
  double? maxCalories;
  FetchFoodLists({
    required this.query,
    this.mealType,
    this.diet,
    this.health,
    this.dishType,
    this.minCalories,
    this.maxCalories,
  }) : super(query: query);
}

class LoadMoreFoodLists extends FoodListEvent {
  final String link;
  const LoadMoreFoodLists({required this.link}) : super(query: link);
}
