import 'package:equatable/equatable.dart';
import 'package:food_recipe/models/ingredient.dart';

class FoodList extends Equatable {
  final String title;
  final String source;
  final String sourceUrl;
  final String img;
  final String link;
  final String thumb;
  final List<Ingredient> ingredients;

  const FoodList(
      {required this.title,
      required this.source,
      required this.sourceUrl,
      required this.img,
      required this.link,
      required this.thumb,
      required this.ingredients});

  @override
  List<Object?> get props =>
      [title, source, sourceUrl, img, link, thumb, ingredients];

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
    };
  }
}
