class Order {
  String name;
  double quantity;
  double price;

  Order({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "price": price,
      };
}
