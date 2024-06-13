import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/product_response.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/utils.dart';

class ProductProvider extends ChangeNotifier {
  static final String _baseUrl = BASE_URL;

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<List<Product>> fetchProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/user/getProducts'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        ProductResponse productResponse =
            ProductResponse.fromJson(jsonResponse);
        _products = productResponse.products;

        return _products;
      } else if (response.statusCode == 401) {
        throw Exception(
            'Parece que tu token ha expirado, por favor vuelve a iniciar sesión');
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (error) {
      rethrow; // Re-lanzamos el error para que el FutureBuilder lo maneje
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
