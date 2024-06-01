import 'package:application/design/food.dart';

class Meal {
  int id;
  Food food1;
  Food food2;
  Food diet;
  Food desert;
  String dailyMeal;
  Meal({
    required this.id,
    required this.food1,
    required this.food2,
    required this.diet,
    required this.desert,
    required this.dailyMeal,
  });
}
