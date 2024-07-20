import 'package:application/design/meal.dart';
import 'package:application/design/shift.dart';

class ShiftMeal {
  int id;
  String date;
  Meal meal;
  Shift shift;
  bool isReserved;
  ShiftMeal({
    required this.id,
    required this.date,
    required this.meal,
    required this.shift,
    required this.isReserved
  });
}
