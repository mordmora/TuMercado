import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/models/User.dart';
import 'package:tu_mercado/models/login_response.dart';
import 'package:tu_mercado/models/neighborhood.dart';
import 'package:tu_mercado/utils.dart';
import 'package:tu_mercado/views/login/login.dart';

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

  Future<LoginResponse> login(String email, String password, String deviceID) async {
    try {
      Map<String, String> data = {
        "email": email,
        "password": password,
        "token": deviceID
      };

      final Uri url = Uri.parse("$baseUrl/user/login");
      print("Attempting login to: $url with email: $email"); // Debug

      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data)).timeout(const Duration(seconds: 10)); // Added timeout

      print("Login API response status: ${response.statusCode}"); // Debug
      print("Login API response body: ${response.body}"); // Debug

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedBody = jsonDecode(response.body);
        final String? token = decodedBody['token'] as String?;
        final String? message = decodedBody['message'] as String?;

        if (token != null && token.isNotEmpty) {
          // Éxito real, token presente
          return LoginResponse(token: token, message: message, statusCode: 0);
        } else {
          // HTTP 200, pero sin token o token vacío, considéralo un error lógico
          return LoginResponse(
            token: token, // puede ser null o vacío
            message: message ?? "Respuesta exitosa pero datos de sesión incompletos.",
            statusCode: 1,
          );
        }
      } else {
        String messageBody = "Error desconocido";
        try {
          messageBody = jsonDecode(response.body)["message"] ?? "Error del servidor: ${response.statusCode}";
        } catch (e) {
          messageBody = "Error al procesar respuesta del servidor: ${response.statusCode}";
        }
        return LoginResponse(
          message: messageBody,
          statusCode: 1,
        );
      }
    } on TimeoutException catch (e) {
      print("Login API timeout: $e"); // Debug
      return LoginResponse(
        message: "Tiempo de espera agotado al conectar con el servidor.",
        statusCode: 1,
      );
    } catch (e) {
      print("Login API general error: $e"); // Debug
      return LoginResponse(
        message: "No se pudo conectar con el servidor: ${e.toString()}",
        statusCode: 1,
      );
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
