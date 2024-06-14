import 'dart:convert';

import 'package:tu_mercado/models/products.dart';

OrderResponse orderResponseFromJson(String str) =>
    OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
  List<Order> orders;

  OrderResponse({
    required this.orders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  String createAt;
  dynamic deliveryId;
  String details;
  String id;
  String link;
  bool payment;
  List<Product> products;
  String status;
  String updateAt;
  String userId;
  double value;

  Order({
    required this.createAt,
    required this.deliveryId,
    required this.details,
    required this.id,
    required this.link,
    required this.payment,
    required this.products,
    required this.status,
    required this.updateAt,
    required this.userId,
    required this.value,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        createAt: json["createAt"],
        deliveryId: json["deliveryId"],
        details: json["details"],
        id: json["id"],
        link: json["link"],
        payment: json["payment"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        status: json["status"],
        updateAt: json["updateAt"],
        userId: json["userId"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "deliveryId": deliveryId,
        "details": details,
        "id": id,
        "link": link,
        "payment": payment,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "status": status,
        "updateAt": updateAt,
        "userId": userId,
        "value": value,
      };
}
