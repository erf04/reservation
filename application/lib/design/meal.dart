import 'package:application/design/food.dart';

class Drink {
  final String name;

  Drink({required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(name: json['name']);
  }
}

class Meal {
  final int id;
  final Food food;
  final Food? diet;
  final Food? desert;
  final String dailyMeal;
  final List<Drink> drink;

  Meal({
    required this.id,
    required this.food,
    required this.diet,
    required this.desert,
    required this.dailyMeal,
    required this.drink,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    //print('going bega');
    List<Drink> myDrinks = [];
    for (var i in json['drinks']) {
      //print('fucking hell');
      myDrinks.add(Drink(name: i['name']));
    }
    return Meal(
        id: json['id'],
        food: Food.fromJson(json['food']),
        diet: Food.fromJson(json['diet']),
        desert: Food.fromJson(json['dessert']),
        dailyMeal: json['daily_meal'],
        drink: myDrinks);
  }
}
