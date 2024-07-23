import 'dart:convert';
import 'package:application/design/user.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class SupervisorAssignmentPage extends StatefulWidget {
  const SupervisorAssignmentPage({super.key});

  @override
  _SupervisorAssignmentPageState createState() =>
      _SupervisorAssignmentPageState();
}

class _SupervisorAssignmentPageState extends State<SupervisorAssignmentPage> {
  late Future<List<User>> futureUsers;
  User? selectedUser;
  Jalali? fromDate;
  Jalali? toDate;

  Future<List<User>> fetchUsers(BuildContext context) async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      final response = await HttpClient.instance.get("api/manager/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      List<User> myUsers = [];
      for (var i in response.data) {
        myUsers.add(User.fromJson(i));
      }
      return myUsers;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers(context);
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300, 1, 1),
      lastDate: Jalali(1450, 12, 29),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  void _submit() async {
    if (selectedUser == null || fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final fromDateIso = fromDate!.toJalaliDateTime().substring(0,10);
    final toDateIso = toDate!.toJalaliDateTime().substring(0,10);
    print(fromDateIso);
    print(toDateIso);

    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      final response = await HttpClient.instance.post("api/manager/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}),
          data: {
            'user': selectedUser!.id,
            'from_date': fromDateIso,
            'to_date': toDateIso
          });
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supervisor assigned successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to assign supervisor')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Supervisor'),
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<User>(
                    decoration: InputDecoration(labelText: 'Select Supervisor'),
                    items: snapshot.data!.map((User user) {
                      return DropdownMenuItem<User>(
                        value: user,
                        child: Text(user.userName),
                      );
                    }).toList(),
                    onChanged: (User? newValue) {
                      setState(() {
                        selectedUser = newValue;
                      });
                    },
                    value: selectedUser,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'From Date'),
                          readOnly: true,
                          onTap: () => _selectDate(context, true),
                          controller: TextEditingController(
                            text: fromDate != null
                                ? fromDate!.formatMediumDate()
                                : '',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'To Date'),
                          readOnly: true,
                          onTap: () => _selectDate(context, false),
                          controller: TextEditingController(
                            text: toDate != null
                                ? toDate!.formatMediumDate()
                                : '',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, false),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Assign Supervisor'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
