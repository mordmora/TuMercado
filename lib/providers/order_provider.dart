import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tu_mercado/models/send_order_model.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends ChangeNotifier {
  static const String _baseUrl = 'http://commixer.pythonanywhere.com';
  Future<String> createNewOrder(OrderData orderData) async {
    try {
      final Uri url = Uri.parse("$_baseUrl/order");
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(orderData.toJson()));
      if (response.statusCode == 200) {
        notifyListeners();
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
