
import 'package:application/design/shiftmeal.dart';
import 'package:application/design/user.dart';

class Reserve {
  int id;
  User user;
  List<ShiftMeal> shiftMeal;

  Reserve({
    required this.id,
    required this.user,
    required this.shiftMeal,
  });
}
