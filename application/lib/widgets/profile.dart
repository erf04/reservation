import 'package:application/design/food.dart';
import 'package:application/design/meal.dart';
import 'package:application/design/reserve.dart';
import 'package:application/design/shift.dart';
import 'package:application/design/shiftmeal.dart';
import 'package:application/design/user.dart';
import 'package:application/gen/assets.gen.dart';
import 'package:application/main.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:application/widgets/loginSignUp_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isInHistory = false;

  Future<List<ShiftMeal>> getReserveHistory() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      print(myAccess);
      final response = await HttpClient.instance.get("api/get-reservations/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      List<ShiftMeal> myList = [];
      for (var i in response.data) {
        Food food1 = Food(
            id: i["meal"]["food1"]["id"],
            name: i["meal"]["food1"]["name"],
            type: i["meal"]["food1"]["type"]);
        Food food2 = Food(
            id: i["meal"]["food2"]["id"],
            name: i["meal"]["food2"]["name"],
            type: i["meal"]["food2"]["type"]);
        Food diet = Food(
            id: i["meal"]["diet"]["id"],
            name: i["meal"]["diet"]["name"],
            type: i["meal"]["diet"]["type"]);
        Food dessert = Food(
            id: i["meal"]["dessert "]["id"],
            name: i["meal"]["dessert"]["name"],
            type: i["meal"]["dessert"]["type"]);
        Meal myMeal = Meal(
            id: i["meal"]["id"],
            food1: food1,
            food2: food2,
            diet: diet,
            desert: dessert,
            dailyMeal: i["meal"]["daily_meal"]);
        Shift myShift =
            Shift(id: i["shift"]["id"], shiftName: i["shift"]["shift_name"]);
        ShiftMeal temp = ShiftMeal(
            id: i["id"], date: i["date"], meal: myMeal, shift: myShift);
        myList.add(temp);
      }
      return myList;
    }
    return [];
  }

  Future<User?> getProfile() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      print(myAccess);
      final response = await HttpClient.instance.get("api/profile/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      User myUser = User(
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
        appBar: myAppBar(context, 'Profile'),
        body: isInHistory
            ? SafeArea(
                child: FutureBuilder<List<ShiftMeal>>(
                future: getReserveHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong!"),
                    );
                  } else if (snapshot.hasData) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: Row(),
                            );
                          }),
                    );
                  } else {
                    return const Center(
                      child: Text(" NO DATA! "),
                    );
                  }
                },
              ))
            : getNormalProfileWidget());
  }

  FutureBuilder<User?> getNormalProfileWidget() {
    return FutureBuilder<User?>(
        future: getProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: SizedBox(height: 10, child: Text("Something went wrong!")),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                    padding: EdgeInsets.fromLTRB(
                        0, 0, 0, MediaQuery.of(context).size.height * 0.7),
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
                        height: MediaQuery.of(context).size.height * 0.35),
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
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Center(child: Icon(Icons.error)),
                                fit: BoxFit.cover,
                                width: 160,
                                height: 160,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              child: Image.asset(
                                'assets/cameraIcon.jpg',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(205, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(snapshot.data!.userName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                IconButton(
                                    onPressed: () {
                                      //todo change user name
                                    },
                                    icon: const Icon(CupertinoIcons.pen))
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: TextButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(205, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Change Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    onPressed: () {
                                      //todo change user name
                                    },
                                    icon: const Icon(CupertinoIcons.pen)),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: TextButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(205, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Text('Change Profile Image',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                IconButton(
                                    onPressed: () {
                                      //todo change user name
                                    },
                                    icon: const Icon(CupertinoIcons.pen))
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: TextButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(205, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Text('Currently In Charge',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Icon(
                                  snapshot.data!.isSuperVisor
                                      ? CupertinoIcons.check_mark
                                      : CupertinoIcons.xmark,
                                ),
                                const SizedBox(
                                  width: 4,
                                )
                              ],
                            ),
                          )),
                    )
                  ],
                )
              ],
            ));
          } else {
            return const Center(
              child: SizedBox(height: 10, child: Text("Something went wrong!")),
            );
          }
        });
  }

  AppBar myAppBar(BuildContext context, String title) {
    return AppBar(
      foregroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                //Navigator.pushReplacement(context, MyHomePage(title: ''));
              },
              icon: const Icon(
                CupertinoIcons.back,
                size: 40,
                color: Color.fromARGB(255, 2, 16, 43),
              )),
          Text(
            title,
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
    );
  }
}
