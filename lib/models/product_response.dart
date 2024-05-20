
import 'package:tu_mercado/models/products.dart';

class ProductResponse {
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Product> products = productList.map((i) => Product.fromJson(i)).toList();

    return ProductResponse(products: products);
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}