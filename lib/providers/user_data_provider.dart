import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/neighborhood.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/utils.dart';

class UserProvider extends ChangeNotifier {
  static final String _baseUrl = BASE_URL;
  bool isLoading = false;
  late UserData _userData;
  Neighborhood? _userNeighborhoodData;

  UserData get userData => _userData;

  Neighborhood get userNeighborhoodData => _userNeighborhoodData!;

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
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        UserData userData = UserData.fromJson(jsonResponse['data']);

        _userData = userData;
        Neighborhood? neighborhood =
            await getUserNeighborhoodData(_userData.neighbordhood);

        notifyListeners();
      } else {
        throw Exception('Error al cargar los datos del usuario');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Neighborhood?> getUserNeighborhoodData(String userNeighborhood) async {
    try {
      final Uri url = Uri.parse("$_baseUrl/admin/getAllNeighborshood");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Neighborhood> neighborhoods = neighborhoodFromJson(response.body);
        Neighborhood neigh = neighborhoods
            .where((element) => element.name == userNeighborhood)
            .first;
        _userNeighborhoodData = neigh;
        return neigh;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
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
