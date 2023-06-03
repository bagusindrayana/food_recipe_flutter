// Event class for the BLoC
import 'package:equatable/equatable.dart';

abstract class FoodDetailEvent extends Equatable {
  const FoodDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchFoodDetails extends FoodDetailEvent {
  const FetchFoodDetails() : super();
}
