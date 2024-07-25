import 'dart:convert';
import 'package:application/design/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class MealReservationsPage extends StatefulWidget {
  @override
  _MealReservationsPageState createState() => _MealReservationsPageState();
}

class _MealReservationsPageState extends State<MealReservationsPage> {
  String? selectedShift;
  Jalali? selectedDate;
  TextEditingController searchController = TextEditingController();
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    selectedShift = 'A'; // Default value
    selectedDate = Jalali.now(); // Default value
    fetchReservations();
  }

  Future<void> _selectDate(BuildContext context) async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: Jalali(1300, 1, 1),
      lastDate: Jalali(1450, 12, 29),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchReservations();
      });
    }
  }

  Future<void> fetchReservations() async {
    final response = await http.get(
      Uri.parse(
          'https://yourbackend.com/api/reservations?shift=$selectedShift&date=${selectedDate!.toIso8601String()}&search=${searchController.text}'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        reservations = jsonResponse
            .map((reservation) => Reservation.fromJson(reservation))
            .toList();
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Reservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedShift,
              onChanged: (String? newValue) {
                setState(() {
                  selectedShift = newValue!;
                  fetchReservations();
                });
              },
              items: ['A', 'B', 'C', 'D']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Select Date'),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? selectedDate!.formatMediumDate()
                          : '',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                fetchReservations();
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Full Name')),
                    DataColumn(label: Text('Lunch')),
                    DataColumn(label: Text('Dinner')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Shift')),
                  ],
                  rows: reservations.map((reservation) {
                    return DataRow(
                      cells: [
                        DataCell(Text(reservation.user.firstName + ' ' + reservation.user.lastName)),
                        DataCell(Text(reservation.lunch)),
                        DataCell(Text(reservation.dinner)),
                        DataCell(Text(selectedDate!.formatMediumDate())),
                        DataCell(Text(selectedShift!)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Reservation {
  final User user;
  final String lunch;
  final String dinner;

  Reservation( {
    required this.user,
    required this.lunch,
    required this.dinner,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      user : User.fromJson(json['user']),
      lunch: json['lunch'],
      dinner: json['dinner'],
    );
  }
}

extension JalaliExtensions on Jalali {
  String toIso8601String() {
    final DateTime gregorian = this.toGregorian().toDateTime();
    return gregorian.toIso8601String();
  }

  String formatFullDate() {
    return '${this.year}/${this.month}/${this.day}';
  }
}
