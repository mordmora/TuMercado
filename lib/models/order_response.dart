import 'dart:convert';

OrderResponse orderResponseFromJson(String str) =>
    OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
  List<ROrder> orders;

  OrderResponse({
    required this.orders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        orders:
            List<ROrder>.from(json["orders"].map((x) => ROrder.fromJson(x))),
      );

  get value => null;

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class ROrder {
  String createAt;
  dynamic deliveryId;
  String details;
  String id;
  String link;
  bool payment;
  List<Products> products;
  String status;
  String updateAt;
  String userId;
  double value;

  ROrder({
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

  factory ROrder.fromJson(Map<String, dynamic> json) => ROrder(
        createAt: json["createAt"],
        deliveryId: json["deliveryId"],
        details: json["details"],
        id: json["id"],
        link: json["link"],
        payment: json["payment"],
        products: List<Products>.from(
            json["products"].map((x) => Products.fromJson(x))),
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

class Products {
  int amount;
  String createAt;
  String description;
  String id;
  String name;
  String orderId;
  double price;
  String stockId;
  String updateAt;

  Products({
    required this.amount,
    required this.createAt,
    required this.description,
    required this.id,
    required this.name,
    required this.orderId,
    required this.price,
    required this.stockId,
    required this.updateAt,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        amount: json["amount"],
        createAt: json["createAt"],
        description: json["description"],
        id: json["id"],
        name: json["name"],
        orderId: json["orderId"],
        price: json["price"],
        stockId: json["stockId"],
        updateAt: json["updateAt"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "createAt": createAt,
        "description": description,
        "id": id,
        "name": name,
        "orderId": orderId,
        "price": price,
        "stockId": stockId,
        "updateAt": updateAt,
      };
}
