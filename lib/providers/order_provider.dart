import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/order_response.dart';
import 'package:tu_mercado/models/send_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/utils.dart';

class OrderProvider extends ChangeNotifier {
  late SharedPreferences prefs;
  static final String _baseUrl = BASE_URL;
  late OrderResponse orderResponse;

  Future<String> createNewOrder(OrderData orderData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString("token") ?? "";

    try {
      final Uri url = Uri.parse("$_baseUrl/user/createOrder");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token"
        },
        body: jsonEncode(orderData.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["message"]["message"];
      } else {
        String messageBody = jsonDecode(response.body)["message"];
        return messageBody;
      }
    } catch (e) {
      return "Error exception $e";
    }
  }
 

  Future<OrderResponse> getOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String _token = prefs.getString("token") ?? "";
      final Uri url = Uri.parse("$_baseUrl/user/getOrders");
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        notifyListeners();
        orderResponse = orderResponseFromJson(response.body);
        return orderResponse;
      } else {
        throw Exception("Error al cargar las ordenes");
      }
    } catch (e) {
      rethrow;
    }
  }
}
