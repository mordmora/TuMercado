import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/models/User.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  final Uri baseUrl = Uri.parse("http://commixer.pythonanywhere.com/");
  bool _rememberMe = false;

  get remembermeValue => _rememberMe;
  set remembermeValue(value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    try {
      Map<String, String> data = {"email": email, "password": password};
      String token = "";
      final Uri url = Uri.parse("${baseUrl}user/login");
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        notifyListeners();
        token = jsonDecode(response.body)["token"];
        return token;
      } else {
        String messageBody = jsonDecode(response.body)["message"];
        return messageBody;
      }
    } catch (e) {
      return "Error exception";
    }
  }

  Future<String> register(User user, String email, String password) async {
    final Uri url = Uri.parse("${baseUrl}user/signUp");
    try {
      Map<String, String> data = {
        "email": email,
        "password": password,
        "firstName": user.name,
        "lastName": user.lastName,
        "birthDate": user.date,
        "phone": user.phone,
        "address": user.adress
      };
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return "output is null";
      } else {
        String messageBody = jsonDecode(response.body)["message"];
        return messageBody + response.statusCode.toString();
      }
    } catch (e) {
      return "Error exception$e";
    }
  }
}
