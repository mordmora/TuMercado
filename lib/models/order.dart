class Order {
  final String name;
  final double quantity;
  final double price;
  final String description;
  final String id;

  Order({
    required this.name,
    required this.quantity,
    required this.price,
    required this.description,
    required this.id,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        description: json["description"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "name": name,
        "quantity": quantity,
        "price": price,
        "id": id,
      };
}
