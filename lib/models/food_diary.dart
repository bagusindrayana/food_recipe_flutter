import 'package:equatable/equatable.dart';

class FoodDiary extends Equatable {
  final int id;
  final String url;
  final String label;
  final double quantity;
  final double calories;
  final DateTime dateTime;
  String? mealType;

  FoodDiary(
      {this.id = 0,
      required this.url,
      required this.label,
      required this.quantity,
      required this.calories,
      required this.dateTime,
      this.mealType});

  @override
  List<Object?> get props =>
      [id, url, label, quantity, calories, dateTime, mealType];

  //from json
  factory FoodDiary.fromJson(Map<String, dynamic> json) {
    return FoodDiary(
        id: json['id'],
        url: json['url'],
        label: json['label'],
        quantity: json['quantity'],
        calories: json['calories'],
        //datetime from string
        dateTime: DateTime.parse(json['dateTime']),
        mealType: json['mealType']);
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'quantity': quantity,
      'calories': calories,
      'dateTime': dateTime.toString(),
      'mealType': mealType
    };
  }

  //copy
  FoodDiary copy(
          {int? id,
          String? url,
          String? label,
          double? quantity,
          double? calories,
          DateTime? dateTime,
          String? mealType}) =>
      FoodDiary(
          id: id ?? this.id,
          url: url ?? this.url,
          label: label ?? this.label,
          quantity: quantity ?? this.quantity,
          calories: calories ?? this.calories,
          dateTime: dateTime ?? this.dateTime,
          mealType: mealType ?? this.mealType);
}
