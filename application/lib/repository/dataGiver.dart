import 'package:application/main.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:flutter/material.dart';

class PostData {
  HttpClient httpClient = HttpClient(baseUrl: "http://10.0.2.2:8000/");

  Future<void> getAuthLogin(
      String myUser, String myPass, context) async {
    final response = await httpClient.getInstance().post('auth/jwt/create/',
        data: {'username': myUser, 'password': myPass});
    if (response.statusCode == 200) {
      TokenManager.saveTokens(response.data["access"], response.data["refresh"]);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)));
    } else {}
  }

}
