import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/mercado_pago_response.dart';
import 'package:tu_mercado/models/send_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/utils.dart';

class OrderProvider extends ChangeNotifier {
  late SharedPreferences prefs;
  static final String _baseUrl = BASE_URL;

  Future<MercadoPagoResponse> createNewOrder(OrderData orderData) async {
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
        return MercadoPagoResponse.fromJson(
            jsonDecode(response.body)["message"]);
      } else {
        String messageBody = jsonDecode(response.body)["message"];
        return MercadoPagoResponse(
          link: "",
          linkSandbox: "",
          message:
              "Error al crear el pedido: $messageBody - Código de estado HTTP: ${response.statusCode}",
          orderId: "",
        );
      }
    } catch (e) {
      return MercadoPagoResponse(
        link: "",
        linkSandbox: "",
        message: "Error: $e",
        orderId: "",
      );
    }
  }
}
