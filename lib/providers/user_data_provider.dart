import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/utils.dart';

class UserProvider extends ChangeNotifier {
  static final String _baseUrl = BASE_URL;
  bool isLoading = false;
  late UserData _userData;

  UserData get userData => _userData;

  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    isLoading = true;
    notifyListeners();
    try {
      final response =
          await http.get(Uri.parse("$_baseUrl/user/getData"), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        UserData userData = UserData.fromJson(jsonResponse['data']);
        print(response.body);
        _userData = userData;
        notifyListeners();
      }
    } catch (error) {}
  }

  Future<String> updateProfile(
      String phone, String address, String neighborhood) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      var response = await http.put(
        Uri.parse('$_baseUrl/user/updateProfile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'phone': phone,
          'address': address,
          'neighborhood': neighborhood,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw Exception('Error al actualizar el perfil');
      }
    } catch (error) {
      rethrow;
    }
  }
}
