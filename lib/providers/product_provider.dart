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

  Future<List<Product>> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/user/getProducts'), headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE1YzdkM2U0LTI3YTUtNGUxZC1hZDIzLTUzMmM3NGFlYmVhZiIsImV4cCI6MTcxNjE4MjU4OX0.j9CpUpva6rWeAvPzV65CdOEpWDH9XBN5t-292Y2xRt0'
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        ProductResponse productResponse =
            ProductResponse.fromJson(jsonResponse);
        _products = productResponse.products;

        return _products;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to fetch products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw error; // Re-lanzamos el error para que el FutureBuilder lo maneje
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
