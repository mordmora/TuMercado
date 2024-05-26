class Order {
  double value;
  String details;

  Order({required this.value, required this.details});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      value: json['value'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'details': details,
    };
  }
}

class Product {
  String name;
  String description;
  double price;
  int amount;
  String stockId;

  Product(
      {required this.name,
      required this.description,
      required this.price,
      required this.amount,
      required this.stockId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      amount: json['amount'],
      stockId: json['stockId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'amount': amount,
      'stockId': stockId,
    };
  }
}

class OrderData {
  Order order;
  List<Product> products;

  OrderData({required this.order, required this.products});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Product> productItems =
        productList.map((i) => Product.fromJson(i)).toList();

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
