class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String createAt;
  final String updateAt;
  final image;

  Product({
    required this.image,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.createAt,
    required this.updateAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['file'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'createAt': createAt,
      'updateAt': updateAt,
      'file': image
    };
  }
}
