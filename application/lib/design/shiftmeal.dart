import 'package:application/design/meal.dart';
import 'package:application/design/shift.dart';

class ShiftMeal {
  int id;
  String date;
  Meal meal;
  Shift shift;
  bool isReserved;
  ShiftMeal(
      {required this.id,
      required this.date,
      required this.meal,
      required this.shift,
      required this.isReserved});

  factory ShiftMeal.fromJson(Map<String, dynamic> json) {
    return ShiftMeal(
        id: json['id'],
        meal: Meal.fromJson(json['meal']),
        shift: Shift.fromJson(json['shift']),
        date: json['date'],
        isReserved: json['is_reserved']);
  }
}
