import 'package:tu_mercado/models/order.dart';

class Order {
  String details;

  Order({required this.details});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details,
    };
  }
}

class OrderData {
  Order order;
  List<ProductOrder> products;

  OrderData({required this.order, required this.products});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<ProductOrder> productItems =
        productList.map((i) => ProductOrder.fromJson(i)).toList();

    return OrderData(
      order: Order.fromJson(json['order']),
      products: productItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order.toJson(),
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
