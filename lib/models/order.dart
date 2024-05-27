class ProductOrder {
  final String name;
  final double quantity;
  final double price;
  final String description;
  final String id;

  ProductOrder({
    required this.name,
    required this.quantity,
    required this.price,
    required this.description,
    required this.id,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) => ProductOrder(
        description: json["description"],
        name: json["name"],
        quantity: json["amount"],
        price: json["price"],
        id: json["stockId"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "name": name,
        "amount": quantity,
        "price": price,
        "stockId": id,
      };
}
