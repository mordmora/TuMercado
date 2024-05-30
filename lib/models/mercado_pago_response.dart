import 'dart:convert';

class MercadoPagoResponse {
  final String link;
  final String linkSandbox;
  final String message;
  final String orderId;

  MercadoPagoResponse({
    required this.link,
    required this.linkSandbox,
    required this.message,
    required this.orderId,
  });

  factory MercadoPagoResponse.fromJson(Map<String, dynamic> json) {
    return MercadoPagoResponse(
      link: json['link'],
      linkSandbox: json['linkSandbox'],
      message: json['message'],
      orderId: json['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = link;
    data['linkSandbox'] = linkSandbox;
    data['message'] = message;
    data['orderId'] = orderId;
    return data;
  }
}
  Future<void> saveOrderToSharedPreferences() async {
    var createdOrders;
    List<String> saveOrder =
        createdOrders.map((order) => jsonEncode(order.toJson())).toList();
    var prefs;
    prefs.setStringList('createdOrders', saveOrder);
  }

    Future<void> readCreatedOrders() async {
    var prefs;
    List<String>? orders = prefs.getStringList('createdOrders');
    if (orders != null) {
      var createdOrders = orders.map((order) {
        return MercadoPagoResponse.fromJson(jsonDecode(order));
      }).toList();
    }
  }