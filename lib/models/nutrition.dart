import 'package:equatable/equatable.dart';

class Nutrition extends Equatable {
  final String id;
  final String label;
  double? quantity;
  String? unit;

  Nutrition({required this.id, required this.label, this.quantity, this.unit});

  @override
  List<Object?> get props => [id, label, quantity, unit];

  //from json
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      id: json['id'],
      label: json['label'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label, 'quantity': quantity, 'unit': unit};
  }
}
