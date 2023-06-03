import 'package:equatable/equatable.dart';

abstract class FoodDetailState extends Equatable {
  const FoodDetailState();

  @override
  List<Object?> get props => [];
}

class FoodDetailInitial extends FoodDetailState {}

class FoodDetailLoading extends FoodDetailState {}

class FoodDetailLoaded extends FoodDetailState {
  final List<String> ingredientTexts;

  const FoodDetailLoaded(this.ingredientTexts);

  @override
  List<Object?> get props => [ingredientTexts];
}

class FoodDetailError extends FoodDetailState {
  final String message;

  const FoodDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
