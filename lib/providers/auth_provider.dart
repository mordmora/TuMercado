import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/models/User.dart';
import 'package:tu_mercado/models/neighborhood.dart';
import 'package:tu_mercado/utils.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  final Uri baseUrl = Uri.parse(BASE_URL);
  bool _rememberMe = false;
  String neighborhood = "";

  set setNeighborhood(String value) {
    neighborhood = value;
    notifyListeners();
  }

  get remembermeValue => _rememberMe;
  set remembermeValue(value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<String> login(String email, String password, String deviceID) async {
    try {
      Map<String, String> data = {
        "email": email,
        "password": password,
        "token": deviceID
      };
      String token = "";
      final Uri url = Uri.parse("$baseUrl" "user/login");

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
      return "Ha ocurrido un error inesperado: $e";
    }
  }

  Future<String> register(User user, String email, String password) async {
    final Uri url = Uri.parse("$baseUrl/user/signUp");

    try {
      Map<String, String> data = {
        "email": email,
        "password": password,
        "firstName": user.name,
        "lastName": user.lastName,
        "birthDate": user.date,
        "phone": user.phone,
        "neighbordhood": neighborhood,
        "address": user.adress
      };
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return "Registro completado";
      } else {
        String messageBody = jsonDecode(response.body)["message"];
        return messageBody;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<Neighborhood>> getNeighborhoods() async {
    try {
      final Uri url = Uri.parse("$baseUrl/admin/getAllNeighborshood");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return neighborhoodFromJson(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
