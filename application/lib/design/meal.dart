import 'package:application/design/food.dart';

class Meal {
  int id;
  Food food;
  Food? diet;
  Food? desert;
  String dailyMeal;
  Meal({
    required this.id,
    required this.food,
    required this.diet,
    required this.desert,
    required this.dailyMeal,
  });
}
