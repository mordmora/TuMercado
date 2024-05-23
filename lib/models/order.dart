class Order {
  final String name;
  final double quantity;
  final double price;
  final String id;

  Order({
    required this.name,
    required this.quantity,
    required this.price,
    required this.id,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "price": price,
        "id": id,
      };
}
