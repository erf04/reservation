import 'package:application/design/meal.dart';
import 'package:application/design/shiftmeal.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:application/widgets/MainPage.dart';
import 'package:application/widgets/SoftenPageTransition.dart';
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
  List<String> shifts = [];
  List<Meal> meals = [];
  String? selectedShift;
  Meal? selectedMeal;
  String? selectedDate;
  var selectedIndex = -1;
  bool internetError = false;
  bool alreadyCreated = false;
  bool success = false;

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
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        setState(() {
          shifts = List<String>.from(data['shifts']);
          meals =
              List<Meal>.from(data['meals'].map((meal) => Meal.fromJson(meal)));
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

  Future<void> submitData() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      final response = await HttpClient.instance.post(
        'api/shiftmeal/create/',
        options: Options(headers: {'Authorization': 'JWT $myAccess'}),
        data: jsonEncode(<String, dynamic>{
          'shift-name': selectedShift!,
          'meal-id': selectedMeal!.id,
          'date': selectedDate!,
        }),
      );
      if (response.statusCode == 201) {
        setState(() {
          success = true;
        });
      } else {
        setState(() {
          internetError = true;
        });
      }
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
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pintrest2.jpg'),
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
                        Card(
                          color: Colors.blueGrey[800]!.withOpacity(0.8),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Shift',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                DropdownButton<String>(
                                  dropdownColor: Colors.blueGrey[800],
                                  hint: Text('Select Shift'),
                                  value: selectedShift,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedShift = newValue;
                                    });
                                  },
                                  items: shifts.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.blueGrey[800]!.withOpacity(0.8),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Date',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey[700],
                                  ),
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
                                        selectedDate =
                                            pickedDate.formatCompactDate();
                                      });
                                    }
                                  },
                                  child: Text(selectedDate == null
                                      ? 'Select Date'
                                      : selectedDate!),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    internetError
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height / 4),
              child: AlertDialog(
                title: const Text('Can\'t Reserve!'),
                content: Text(
                  "You can't reserve this meal.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        internetError = false;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            )
          : success
              ? Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, 0, MediaQuery.of(context).size.height / 4),
                  child: AlertDialog(
                    title: const Text('Reserved successfully!'),
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
              : Expanded(
                  child: ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        //print(snapshot.data![index]);
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: selectedIndex == index
                                  ? MediaQuery.of(context).size.height * (2 / 5)
                                  : 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white60,
                                  boxShadow: const [BoxShadow(blurRadius: 4)]),
                              child: Padding(
                                padding: selectedIndex == index
                                    ? const EdgeInsets.all(32)
                                    : const EdgeInsets.all(16.0),
                                child: selectedIndex == index
                                    ? _columnMethod(
                                        meals!,
                                        index,
                                        context,
                                      )
                                    : _rowMethod(
                                        meals!,
                                        index,
                                        context,
                                      ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[900],
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: selectedShift != null &&
                              selectedMeal != null &&
                              selectedDate != null
                          ? submitData
                          : null,
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

  Column _columnMethod(
      List<Meal> shiftMeal, int index, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (selectedIndex != index) {
                        selectedIndex = index;
                      } else {
                        selectedIndex = -1;
                      }
                    });
                  },
                  child: Text(
                    'Shift : ${shiftMeal[index].food.name}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 1 / 8, 0, 0, 0),
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    height: 30,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: shiftMeal[index].drink.length + 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index1) {
                          if (index1 == 0) {
                            return Container(
                                margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                child: Text('drinks : ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w300)));
                          }
                          if (index1 == shiftMeal[index].drink.length) {
                            return Container(
                                margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                child: Text(
                                    shiftMeal[index]
                                        .drink[index1 - 1]
                                        .name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w300)));
                          } else {
                            return Container(
                                margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                child: Text(
                                    '${shiftMeal[index].drink[index1 - 1]} -',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w300)));
                          }
                        }),
                  ),
                  SizedBox(),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                  shiftMeal[index].diet == null
                      ? 'diet : no diet food available'
                      : 'diet : ${shiftMeal[index].diet!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 19, fontWeight: FontWeight.w300)),
              const SizedBox(
                height: 8,
              ),
              Text(
                  shiftMeal[index].desert == null
                      ? 'dessert : no dessert food available'
                      : 'dessert : ${shiftMeal[index].desert!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 19, fontWeight: FontWeight.w300)),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await submitData();
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: Text("Reserve",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)))
            ],
          ),
        )
      ],
    );
  }

  Row _rowMethod(List<Meal> shiftMeals, int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(shiftMeals[index].food.name,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 19)),
        Text(
          shiftMeals[index].dailyMeal,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 19),
        ),
        Text(
          shiftMeals[index].id.toString(),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 19),
        ),
      ],
    );
  }
}



// class NewMealPage extends StatefulWidget {
//   @override
//   _NewMealPageState createState() => _NewMealPageState();
// }

// class _NewMealPageState extends State<NewMealPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _mealName = '';
//   String _mealDescription = '';
//   XFile? _mealImage;
//   bool internetError = false;

//   final ImagePicker _picker = ImagePicker();

//   Future<Map<String, dynamic>> getCreationOptions() async {
//     VerifyToken? myVerify = await TokenManager.verifyAccess(context);
//     if (myVerify == VerifyToken.verified) {
//       String? myAccess = await TokenManager.getAccessToken();
//       final response = await HttpClient.instance
//           .get('api/shiftmeal/create/',
//               options: Options(headers: {"Authorization": "JWT $myAccess"}))
//           .catchError((error) {
//         setState(() {
//           this.internetError = true;
//         });
//       }).then((onValue) {
//         for(var i in )
//         Map<String, dynamic> myMap = {};
//       });
//     }
//   }

//   // Future<void> _pickImage() async {
//   //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   //   setState(() {
//   //     _mealImage = pickedFile;
//   //   });
//   // }

//   void _saveMeal() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       // Save the meal to your database or state management solution here

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Meal Saved')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: SafeArea(child: child),
//     );
//   }
// }
