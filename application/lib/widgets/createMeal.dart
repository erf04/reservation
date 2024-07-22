import 'package:application/design/meal.dart';
import 'package:application/design/user.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:application/widgets/MainPage.dart';
import 'package:application/widgets/SoftenPageTransition.dart';
import 'package:application/widgets/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class MealCreationPage extends StatefulWidget {
  @override
  _MealCreationPageState createState() => _MealCreationPageState();
}

class _MealCreationPageState extends State<MealCreationPage> {
  List<String> shifts = ['A', 'B', 'C', 'D'];
  List<Meal> meals = [];
  String? selectedShift;
  List<Meal?> selectedMeals = [];
  String? selectedDate;
  var _selectedDate;
  int selectedIndex = -1;
  bool internetError = false;
  bool alreadyCreated = false;
  bool success = false;
  bool selectedLaunch = false;
  bool selectedDinner = false;
  bool selectedCreateNew = false;
  List<Meal> _selectedLunchMeals = [];
  List<Meal> _selectedDinnerMeals = [];
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      final response = await HttpClient.instance.get('api/shiftmeal/create/',
          options: Options(headers: {'Authorization': 'JWT $myAccess'}));
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          for (var i in response.data['meals']) {
            meals.add(Meal.fromJson(i));
          }
        });
      } else {
        setState(() {
          if (response.statusCode == 306) {
            alreadyCreated = true;
          } else {
            internetError = true;
          }
        });
      }
    }
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

  Future<void> submitData() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      selectedDate = selectedDate!.replaceAll('/', '-');
      //print("WHAT THE FUCK");
      print(selectedMeals);
      for (var i in selectedMeals) {
        final response = await HttpClient.instance.post(
          'api/shiftmeal/create/',
          options: Options(headers: {'Authorization': 'JWT $myAccess'}),
          data: jsonEncode(<String, dynamic>{
            'shift-name': selectedShift!,
            'meal-id': i!.id,
            'date': selectedDate!,
          }),
        );
        if (response.statusCode == 201) {
        } else {
          setState(() {
            internetError = true;
          });
        }
      }

      setState(() {
        success = true;
        selectedDate = null;
        selectedMeals = [];
        selectedShift = null;
      });
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
                onPressed: () {
                  FadePageRoute.navigateToNextPage(context, MainPage());
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  size: 40,
                  color: Color.fromARGB(255, 2, 16, 43),
                )),
            Text(
              'Create Meal',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<User?>(
                future: getProfileForMainPage(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return InkWell(
                      onTap: () {
                        FadePageRoute.navigateToNextPage(context, Profile());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        radius: 20,
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
                                width: 40,
                                height: 40),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return IconButton(
                        onPressed: () {
                          FadePageRoute.navigateToNextPage(context, Profile());
                        },
                        icon: Icon(CupertinoIcons.profile_circled));
                  }
                }),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/new7.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          child: Card(
                            color: Colors.white38!.withOpacity(0.8),
                            margin: EdgeInsets.all(0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Shift',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: DropdownButton<String>(
                                      dropdownColor:
                                          Color.fromARGB(255, 237, 193, 115),
                                      hint: Text('Select Shift'),
                                      value: selectedShift,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedShift = newValue;
                                        });
                                      },
                                      items: shifts
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          child: Card(
                            color: Colors.white38!.withOpacity(0.8),
                            margin: EdgeInsets.all(0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Date',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black26,
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width,
                                            10)),
                                    onPressed: () async {
                                      Jalali? pickedDate =
                                          await showPersianDatePicker(
                                        context: context,
                                        initialDate: Jalali.now(),
                                        firstDate: Jalali(1385, 8),
                                        lastDate: Jalali(1450, 9),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _selectedDate = pickedDate;
                                          selectedDate =
                                              pickedDate.formatCompactDate();
                                        });
                                      }
                                    },
                                    child: Text(
                                      selectedDate == null
                                          ? 'Select Date'
                                          : selectedDate!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    success
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0,
                                MediaQuery.of(context).size.height / 4),
                            child: AlertDialog(
                              title: const Text('Created successfully!'),
                              content: Text(
                                "Click ok to resume.",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      success = false;
                                      selectedIndex = -1;
                                    });
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height:
                                MediaQuery.of(context).size.height * (4 / 7) +
                                    10,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  _buildMealSection(
                                      'Lunch', _selectedLunchMeals),
                                  SizedBox(height: 16),
                                  _buildMealSection(
                                      'Dinner', _selectedDinnerMeals),
                                ]),
                          ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      onPressed: () async {
                        if (_selectedDate != null &&
                            (!selectedMeals.isEmpty) &&
                            selectedShift != null) {
                          await submitData();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(String title, List<Meal> selectedMeals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: selectedMeals.map((meal) {
            return Chip(
              label: Text(meal.food.name),
              onDeleted: () {
                setState(() {
                  selectedMeals.remove(meal);
                  this.selectedMeals.remove(meal);
                  this.selectedMeals.remove(meal);
                });
              },
            );
          }).toList(),
        ),
        if (selectedMeals.length < 2)
          ElevatedButton(
            onPressed: () async {
              final selectedMeal = await _showMealSelectionDialog();
              if (selectedMeal != null) {
                setState(() {
                  selectedMeals.add(selectedMeal);
                  this.selectedMeals.add(selectedMeal);
                  //print(selectedMeals);
                });
              }
            },
            child: Text('Add $title Meal'),
          ),
      ],
    );
  }

  Future<Meal?> _showMealSelectionDialog() async {
    return showDialog<Meal>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a Meal'),
          content: Container(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: meals
                  .map((meal) => ListTile(
                        title: Text(meal.food.name),
                        onTap: () {
                          Navigator.pop(
                              context, meal); // Return the Meal object
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context,
                    null); // Returning null to indicate creation of new meal
              },
              child: Text('Create New Meal'),
            ),
          ],
        );
      },
    );
  }
}
