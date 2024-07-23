import 'package:application/design/food.dart';
import 'package:flutter/src/material/list_tile.dart';

class Drink {
  final String name;
  final int id;
  Drink( {required this.id,required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(name: json['name'],
      id: json['id']);
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
      myDrinks.add(Drink(name: i['name'], id: i['id']));
    }
    return Meal(
        id: json['id'],
        food: Food.fromJson(json['food']),
        diet: json['diet']!=null ? Food.fromJson(json['diet']) : null,
        desert: json['dessert']!=null ? Food.fromJson(json['dessert']) : null,
        dailyMeal: json['daily_meal'],
        drink: myDrinks);
  }
}
