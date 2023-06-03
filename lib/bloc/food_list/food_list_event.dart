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
  const FetchFoodLists({required this.query}) : super(query: query);
}

class LoadMoreFoodLists extends FoodListEvent {
  final String link;
  const LoadMoreFoodLists({required this.link}) : super(query: link);
}
