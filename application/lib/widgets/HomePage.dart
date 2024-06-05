import 'package:application/design/food.dart';
import 'package:application/design/meal.dart';
import 'package:application/design/reserve.dart';
import 'package:application/design/shift.dart';
import 'package:application/design/shiftmeal.dart';
import 'package:application/design/user.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  Future<User?> getProfileForMainPage() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      //print(myAccess);
      final response = await HttpClient.instance.get("api/profile/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      User myUser = User(
          isShiftManager: response.data["is_shift_manager"],
          isSuperVisor: response.data["is_supervisor"],
          id: response.data["id"],
          userName: response.data["username"],
          profilePhoto: response.data["profile"]);
      return myUser;
    }
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
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.back,
                    size: 40,
                    color: Color.fromARGB(255, 2, 16, 43),
                  )),
              Text(
                'Main Page',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    //Navigator.pushReplacement(context, MyHomePage(title: ''));
                  },
                  icon: const Icon(
                    CupertinoIcons.mail,
                    size: 40,
                    color: Color.fromARGB(255, 2, 16, 43),
                  )),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: FutureBuilder<User?>(
              future: getProfileForMainPage(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: SizedBox(
                        height: 10, child: Text("Something went wrong!")),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return SafeArea(
                      child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          //color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage('assets/pintrest2.jpg'),
                            fit: BoxFit
                                .cover, // This ensures the image covers the entire background
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0,
                              MediaQuery.of(context).size.height * 0.7),
                          child: Container(
                              decoration: const BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: AssetImage('assets/pintrest2.jpg'),
                                  //   fit: BoxFit
                                  //       .cover, // This ensures the image covers the entire background
                                  // ),
                                  color: Colors.white,
                                  boxShadow: const [BoxShadow(blurRadius: 2)],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(24),
                                      bottomRight: Radius.circular(24))),
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.35),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.deepOrange,
                                radius: 80,
                                child: ClipOval(
                                  child: Container(
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'http://10.0.2.2:8000${snapshot.data?.profilePhoto}',
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(child: Icon(Icons.error)),
                                        fit: BoxFit.cover,
                                        width: 160,
                                        height: 160),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Column(),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                height:
                                    MediaQuery.of(context).size.height * 2 / 5,
                                child: FutureBuilder(
                                    future: getPendingReservations(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: SizedBox(
                                              height: 30,
                                              child: Column(
                                                children: [
                                                  Text(
                                                      snapshot.error.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color: Colors
                                                                  .white)),
                                                  Text(
                                                    "Something went wrong!",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ],
                                              )),
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasData) {
                                        return Expanded(
                                          child: ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                //print(snapshot.data![index]);
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1 /
                                                            3,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color: Colors.white60,
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              blurRadius: 4)
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: _rowMethod(
                                                        snapshot.data!,
                                                        index,
                                                        context,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                      } else {
                                        return Center(
                                            child: Text("NO DATA!",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Colors.white)));
                                      }
                                    }),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ));
                } else {
                  return const Center(
                    child: SizedBox(
                        height: 10, child: Text("Something went wrong!")),
                  );
                }
              }),
        ));
  }

  Row _rowMethod(List<Reserve> reserves, int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(reserves[index].shiftMeal.shift.shiftName,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 19)),
        Text(
          reserves[index].shiftMeal.date,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 19),
        ),
        IconButton(
            hoverColor: Colors.red,
            onPressed: () {
              setState(() {
                deleteReservation(reserves[index].id);
              });
            },
            icon: const Icon(
              CupertinoIcons.delete,
            ))
      ],
    );
  }
}
