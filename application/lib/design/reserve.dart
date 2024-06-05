// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:application/design/shiftmeal.dart';
import 'package:application/design/user.dart';

class Reserve {
  int id;
  User user;
  List<ShiftMeal> shiftMeal;
  String date;

  Reserve({
    required this.id,
    required this.user,
    required this.shiftMeal,
    required this.date,
  });
}
