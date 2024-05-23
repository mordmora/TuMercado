import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  static const String _baseUrl = 'http://commixer.pythonanywhere.com';
  bool isLoading = false;
  late UserData _userData;

  UserData get userData => _userData;

  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    isLoading = true;

    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/user/getData'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        //print(response.body);
        var jsonResponse = json.decode(response.body);
        UserData userData = UserData.fromJson(jsonResponse['data']);
        _userData = userData;
      } else {
        throw Exception('Error al cargar los datos del usuario');
      }
    } catch (error) {
      rethrow;
    }
  }
}
