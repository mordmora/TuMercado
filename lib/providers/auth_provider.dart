import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:tu_mercado/models/User.dart';
import 'package:tu_mercado/models/neighborhood.dart';
import 'package:tu_mercado/utils.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  final Uri baseUrl = Uri.parse(BASE_URL);
  bool _rememberMe = false;
  String neighborhood = "";
  final connection = InternetConnection.createInstance(customCheckOptions: [
    InternetCheckOption(
      uri: Uri.parse(BASE_URL),
    ),
  ]);

  set setNeighborhood(String value) {
    neighborhood = value;
    print("Barrio: " + neighborhood);
    notifyListeners();
  }

  get remembermeValue => _rememberMe;
  set remembermeValue(value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    bool hasInternetConnection = await connection.hasInternetAccess;
    if (!hasInternetConnection) {
      return "No se ha podido conectar con el servidor, por favor revisa tu conexión a internet.";
    }
    try {
      Map<String, String> data = {"email": email, "password": password};
      String token = "";
      final Uri url = Uri.parse("$baseUrl/user/login");
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

    bool hasInternetConnection = await connection.hasInternetAccess;

    if (!hasInternetConnection) {
      return "No se ha podido conectar con el servidor, por favor revisa tu conexión a internet.";
    }
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
