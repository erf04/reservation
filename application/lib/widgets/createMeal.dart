import 'package:application/design/meal.dart';
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
  List<String> shifts = ['A', 'B', 'C', 'D'];
  List<Meal> meals = [];
  String? selectedShift;
  Meal? selectedMeal;
  String? selectedDate;
  int selectedIndex = -1;
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

  Future<void> submitData() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      selectedDate = selectedDate!.replaceAll('/', '-');
      print("WHAT THE FUCK");
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
          selectedDate = null;
          selectedMeal = null;
          selectedShift = null;
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
                          color: Colors.white38!.withOpacity(0.8),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
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
                                DropdownButton<String>(
                                  dropdownColor: Colors.blueGrey,
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
                                          style:
                                              TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white38!.withOpacity(0.8),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black26,
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
                                      : selectedDate!,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: Colors.white
                                      ),),
                                ),
                              ],
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
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.6,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: selectedIndex == index
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                (2 / 7)
                                            : 75,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Colors.white60,
                                            boxShadow: const [
                                              BoxShadow(blurRadius: 4)
                                            ]),
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
                        backgroundColor: Colors.white54,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      onPressed: () {
                        setState(() async {
                          print("WHAT THE FUCK IS HAPPENING");
                          if (selectedDate != null &&
                              selectedMeal != null &&
                              selectedShift != null) {
                            submitData();
                            ;
                          }
                        });
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

  Column _columnMethod(List<Meal> myMeal, int index, BuildContext context) {
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
                    'foods: ${myMeal[index].food.name}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
              Text(
                  myMeal[index].diet == null
                      ? 'diet: no diet food available'
                      : 'diet: ${myMeal[index].diet!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 19, fontWeight: FontWeight.w300)),
              Text(
                  myMeal[index].desert == null
                      ? 'dessert: no dessert food available'
                      : 'dessert: ${myMeal[index].desert!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 19, fontWeight: FontWeight.w300)),
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
                        itemCount: myMeal[index].drink.length + 1,
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
                          if (index1 == myMeal[index].drink.length) {
                            return Container(
                                margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                child: Text(
                                    myMeal[index].drink[index1 - 1].name,
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
                                    '${myMeal[index].drink[index1 - 1].name} -',
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
        SizedBox(),
        IconButton(
            onPressed: () {
              setState(() {
                selectedMeal = shiftMeals[index];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Meal Selected')),
                );
              });
            },
            icon: selectedMeal!=null && selectedMeal==shiftMeals[index]? Icon(CupertinoIcons.check_mark) : Icon(CupertinoIcons.plus_app))
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
