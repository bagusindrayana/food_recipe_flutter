import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'food_diary_event.dart';
part 'food_diary_state.dart';

class FoodDiaryBloc extends Bloc<FoodDiaryEvent, FoodDiaryState> {
  FoodDiaryBloc() : super(FoodDiaryInitial()) {
    on<FoodDiaryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
