import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/components/button.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/main.dart';
import 'package:tu_mercado/models/mercado_pago_response.dart';
import 'package:tu_mercado/models/order.dart';
import 'package:tu_mercado/models/send_order_model.dart';
import 'package:tu_mercado/providers/order_provider.dart';
import 'package:tu_mercado/utils.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with RouteAware {
  late SharedPreferences prefs;
  List<ProductOrder> clientOrders = List.empty(growable: true);
  bool isLoading = true; // Variable para controlar la carga de datos
  String _response = "";
  List<MercadoPagoResponse> createdOrders = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await readFromSharedPreferences();
    await readCreatedOrders();
    setState(() {
      isLoading = false; // Indica que la carga ha terminado
    });
  }

  Future<void> readFromSharedPreferences() async {
    List<String>? orders = prefs.getStringList('orders');
    if (orders != null) {
      clientOrders = orders.map((order) {
        return ProductOrder.fromJson(jsonDecode(order));
      }).toList();
    }
  }

  Future<void> readCreatedOrders() async {
    List<String>? orders = prefs.getStringList('createdOrders');
    print(orders?.length);
    if (orders != null) {
      createdOrders = orders.map((order) {
        return MercadoPagoResponse.fromJson(jsonDecode(order));
      }).toList();
    }
  }

  Future<void> saveToSharedPreferences() async {
    List<String> productOrders = clientOrders
        .map((productOrder) => jsonEncode(productOrder.toJson()))
        .toList();
    prefs.setStringList('orders', productOrders);
  }

  Future<void> saveOrderToSharedPreferences() async {
    List<String> saveOrder =
        createdOrders.map((order) => jsonEncode(order.toJson())).toList();
    prefs.setStringList('createdOrders', saveOrder);
  }

  @override
  void dispose() {
    super.dispose();
  }

  double getTotalPrice() {
    double total = 0;
    for (ProductOrder order in clientOrders) {
      total += order.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: clientOrders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_sharp,
                    size: 100,
                  ),
                  Text(
                    "El carrito está vacío",
                    style: TextStyles.subtitle,
                  )
                ],
              ),
            )
          : Stack(
              children: [
                ListView.builder(
                  itemCount: clientOrders.length,
                  itemBuilder: (context, index) {
                    ProductOrder order = clientOrders[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 5))
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Palette.green),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.name,
                                  style: TextStyles.subtitle,
                                ),
                                Text(
                                  "Cantidad: ${order.quantity.toInt()}",
                                  style: TextStyles.subtitle,
                                ),
                                Text(
                                  "Precio: ${getFormatMoneyString(order.price.toDouble())}\$",
                                  style: TextStyles.subtitle,
                                ),
                              ],
                            ),
                            const Spacer(),
                            CupertinoButton(
                                child: const Icon(Icons.delete,
                                    color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    clientOrders.removeAt(index);
                                    prefs.setStringList(
                                        'orders',
                                        clientOrders
                                            .map((order) =>
                                                jsonEncode(order.toJson()))
                                            .toList());
                                  });
                                })
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      label: 'Realizar pedido',
                      color: Colors.black,
                      labelColor: Colors.white,
                      height: 55,
                      width: 200,
                      onTap: () {
                        OrderData orderData = OrderData(
                          order: Order(value: getTotalPrice(), details: ""),
                          products: clientOrders,
                        );

                        Provider.of<OrderProvider>(context, listen: false)
                            .createNewOrder(orderData)
                            .then((value) => {
                                  _response = value.link,
                                  createdOrders.add(value),
                                })
                            .whenComplete(() {
                          clientOrders.clear();
                          saveToSharedPreferences();
                          saveOrderToSharedPreferences();

                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(""),
                                    content: Text(_response),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Ok"))
                                    ],
                                  ));
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
