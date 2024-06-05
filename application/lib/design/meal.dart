// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:application/design/food.dart';

class Meal {
  int id;
  Food food;
  Food? diet;
  Food? desert;
  String dailyMeal;
  List<String> drink;
  Meal({
    required this.id,
    required this.food,
    required this.diet,
    required this.desert,
    required this.dailyMeal,
    required this.drink,
  });
}
