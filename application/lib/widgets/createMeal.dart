import 'package:application/design/food.dart';
import 'package:application/design/meal.dart';
import 'package:application/design/reserve.dart';
import 'package:application/design/shift.dart';
import 'package:application/design/shiftmeal.dart';
import 'package:application/design/user.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:application/widgets/SoftenPageTransition.dart';
import 'package:application/widgets/loginSignUp_state.dart';
import 'package:application/widgets/profile.dart';
import 'package:application/widgets/reservation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class CreateFood extends StatefulWidget {
  @override
  _CreateFoodState createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
  Future<void> deleteReservation(int deletedId) async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      final response = await HttpClient.instance.delete(
          "api/delete-reservation/$deletedId/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
    }
  }

  Future<List<Reserve>> getPendingReservations() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      final response = await HttpClient.instance.get("api/pending-list/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      print(response.data);
      List<Reserve> myList = [];
      for (var j in response.data) {
        var i = j["shift_meal"];
        Food food1 = Food(
            id: i["meal"]["food"]["id"],
            name: i["meal"]["food"]["name"],
            type: i["meal"]["food"]["type"]);
        //print('moz1');
        Food? diet;
        if (i["meal"]["diet"] == null) {
          diet = null;
        } else {
          diet = Food(
              id: i["meal"]["diet"]["id"],
              name: i["meal"]["diet"]["name"],
              type: i["meal"]["diet"]["type"]);
        }
        //print('moz2');
        Food? dessert;
        if (i["meal"]["dessert"] == null) {
          dessert = null;
        } else {
          dessert = Food(
              id: i["meal"]["dessert"]["id"],
              name: i["meal"]["dessert"]["name"],
              type: i["meal"]["dessert"]["type"]);
        }
        //print('moz3');
        List<String> myDrinks = [];
        for (var j in i["meal"]["drinks"]) {
          myDrinks.add(j['name']);
        }
        //print('moz4');
        Meal myMeal = Meal(
            id: i["meal"]["id"],
            drink: myDrinks,
            food: food1,
            diet: diet,
            desert: dessert,
            dailyMeal: i["meal"]["daily_meal"]);
        print('moz5');
        Shift myShift =
            Shift(id: i["shift"]["id"], shiftName: i["shift"]["shift_name"]);
        ShiftMeal temp1 = ShiftMeal(
            id: i["id"], date: i["date"], meal: myMeal, shift: myShift);
        Reserve temp = Reserve(
            id: j['id'],
            user: User(
                id: j['user']['id'],
                userName: j['user']['username'],
                profilePhoto: j['user']['profile'],
                isSuperVisor: j['user']['is_supervisor'],
                isShiftManager: j['user']["is_shift_manager"]),
            shiftMeal: temp1,
            date: j['date']);

        myList.add(temp);
      }
      return myList;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    FadePageRoute.navigateToNextPage(
                        context, const LoginSignUp());
                  },
                  icon: const Icon(
                    CupertinoIcons.back,
                    size: 40,
                    color: Color.fromARGB(255, 2, 16, 43),
                  )),
              Text(
                'Create Food',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.mail,
                    size: 40,
                    color: Color.fromARGB(255, 2, 16, 43),
                  )),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body:SafeArea(child: Container()) 
      );
  }
}
