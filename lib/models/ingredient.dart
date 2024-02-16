import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String text;
  final double quantity;
  final String? measure;
  final String? image;

  const Ingredient(
      {required this.text, required this.quantity, this.measure, this.image});

  @override
  List<Object?> get props => [text, quantity, measure, image];

  //from json
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      text: json['text'],
      quantity: json['quantity'],
      measure: json['measure'],
      image: json['image'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'quantity': quantity,
      'measure': measure,
      'image': image,
    };
  }
}
