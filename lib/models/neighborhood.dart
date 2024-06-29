import 'dart:convert';

// Clase para representar un vecindario
class Neighborhood {
  String id;
  String name;
  double price;
  String createAt;
  String updateAt;

  // Constructor
  Neighborhood({
    required this.id,
    required this.name,
    required this.price,
    required this.createAt,
    required this.updateAt,
  });

  // Método para crear una instancia de Neighborhood desde un JSON
  factory Neighborhood.fromJson(Map<String, dynamic> json) {
    return Neighborhood(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }

  // Método para convertir una instancia de Neighborhood a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'createAt': createAt,
      'updateAt': updateAt,
    };
  }
}

// Función para crear una lista de Neighborhoods desde un JSON
List<Neighborhood> neighborhoodFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Neighborhood>.from(
      jsonData['neighbordhoods'].map((x) => Neighborhood.fromJson(x)));
}

// Función para convertir una lista de Neighborhoods a JSON
String neighborhoodToJson(List<Neighborhood> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode({'neighbordhoods': dyn});
}
