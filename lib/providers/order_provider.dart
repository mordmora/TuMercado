import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/send_order_model.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends ChangeNotifier {


 /*
  TODO: 
  */


  late SharedPreferences prefs;
  String _token = "";
  static const String _baseUrl = 'http://commixer.pythonanywhere.com';
  Future<String> createNewOrder(OrderData orderData) async {
    try {
      prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token") ?? "";
      final Uri url = Uri.parse("$_baseUrl/user/createOrder");
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          },
          body: jsonEncode(orderData.toJson()));
      if (response.statusCode == 200) {
        notifyListeners();
        return "output is null";
      } else {
        String messageBody = jsonDecode(response.body)["message"];
        return messageBody + response.statusCode.toString();
      }
    } catch (e) {
      return "$e";
    }
  }
}
