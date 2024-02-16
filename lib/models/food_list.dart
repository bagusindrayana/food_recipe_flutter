import 'package:equatable/equatable.dart';
import 'package:food_recipe/models/ingredient.dart';
import 'package:food_recipe/models/nutrition.dart';

class FoodList extends Equatable {
  final String title;
  final String source;
  final String sourceUrl;
  final String img;
  final String link;
  final String thumb;
  final List<Ingredient> ingredients;
  final String detailLink;
  final double calories;
  final List<String> cuisineType;
  final List<String> mealType;
  final List<String> dishType;
  final List<String> dietLabels;
  final List<String> healthLabels;
  final List<Nutrition> totalNutrients;

  const FoodList(
      {required this.title,
      required this.source,
      required this.sourceUrl,
      required this.img,
      required this.link,
      required this.thumb,
      required this.ingredients,
      required this.detailLink,
      required this.calories,
      required this.cuisineType,
      required this.mealType,
      required this.dishType,
      required this.dietLabels,
      required this.healthLabels,
      required this.totalNutrients});

  @override
  List<Object?> get props => [
        title,
        source,
        sourceUrl,
        img,
        link,
        thumb,
        ingredients,
        detailLink,
        calories,
        cuisineType,
        mealType,
        dishType,
        dietLabels,
        healthLabels,
        totalNutrients
      ];

  //from json
  factory FoodList.fromJson(Map<String, dynamic> json) {
    return FoodList(
      title: json['title'],
      source: json['source'],
      sourceUrl: json['sourceUrl'],
      img: json['img'],
      link: json['link'],
      thumb: json['thumb'],
      ingredients: (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      detailLink: json['detailLink'],
      calories: json['calories'],
      cuisineType:
          (json['cuisineType'] as List).map((e) => e.toString()).toList(),
      mealType: (json['mealType'] as List).map((e) => e.toString()).toList(),
      dishType: (json['dishType'] as List).map((e) => e.toString()).toList(),
      dietLabels:
          (json['dietLabels'] as List).map((e) => e.toString()).toList(),
      healthLabels:
          (json['healthLabels'] as List).map((e) => e.toString()).toList(),
      totalNutrients: (json['totalNutrients'] as List)
          .map((e) => Nutrition.fromJson(e))
          .toList(),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'source': source,
      'sourceUrl': sourceUrl,
      'img': img,
      'link': link,
      'thumb': thumb,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'detailLink': detailLink,
    };
  }
}
