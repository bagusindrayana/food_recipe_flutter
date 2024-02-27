import 'package:equatable/equatable.dart';

class FoodFavorite extends Equatable {
  final int id;
  final String url;
  final String label;
  final DateTime dateTime;
  String? mealType;

  FoodFavorite(
      {this.id = 0,
      required this.url,
      required this.label,
      required this.dateTime,
      this.mealType});

  @override
  List<Object?> get props => [id, url, label, dateTime, mealType];

  //from json
  factory FoodFavorite.fromJson(Map<String, dynamic> json) {
    return FoodFavorite(
        id: json['id'],
        url: json['url'],
        label: json['label'],
        //datetime from string
        dateTime: DateTime.parse(json['dateTime']),
        mealType: json['mealType']);
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'dateTime': dateTime.toString(),
      'mealType': mealType
    };
  }

  //copy
  FoodFavorite copy(
          {int? id,
          String? url,
          String? label,
          DateTime? dateTime,
          String? mealType}) =>
      FoodFavorite(
          id: id ?? this.id,
          url: url ?? this.url,
          label: label ?? this.label,
          dateTime: dateTime ?? this.dateTime,
          mealType: mealType ?? this.mealType);
}
