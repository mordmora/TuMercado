import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tu_mercado/models/product_response.dart';
import 'package:tu_mercado/models/products.dart';

class ProductProvider extends ChangeNotifier {
  static const String _baseUrl = 'http://commixer.pythonanywhere.com';

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
          Uri.parse('http://commixer.pythonanywhere.com/user/getProducts'),
          headers: {
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        ProductResponse productResponse =
            ProductResponse.fromJson(jsonResponse);
        _products = productResponse.products;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
