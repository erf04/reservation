import 'package:application/design/meal.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:dio/dio.dart';
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
        setState(() {});
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
        title: Text('Create Shift Meal'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                        items: shifts
                            .map<DropdownMenuItem<String>>((String value) {
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
                        'Select Meal',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      DropdownButton<Meal>(
                        dropdownColor: Colors.blueGrey[800],
                        hint: Text('Select Meal'),
                        value: selectedMeal,
                        onChanged: (Meal? newValue) {
                          setState(() {
                            selectedMeal = newValue;
                          });
                        },
                        items: meals.map<DropdownMenuItem<Meal>>((Meal meal) {
                          return DropdownMenuItem<Meal>(
                            value: meal,
                            child: Text(meal.food.name,
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                        ),
                        onPressed: () async {
                          Jalali? pickedDate = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1385, 8),
                            lastDate: Jalali(1450, 9),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate.formatCompactDate();
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//                 onPressed: () {
//                   FadePageRoute.navigateToNextPage(context, MainPage());
//                 },
//                 icon: const Icon(
//                   CupertinoIcons.back,
//                   size: 40,
//                   color: Color.fromARGB(255, 2, 16, 43),
//                 )),
//             Text(
//               'Main Page',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
//             ),
//             IconButton(
//                 onPressed: () {},
//                 icon: const Icon(
//                   CupertinoIcons.mail,
//                   size: 40,
//                   color: Color.fromARGB(255, 2, 16, 43),
//                 )),
//           ],
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: SafeArea(child: child),
//     );
//   }
// }
