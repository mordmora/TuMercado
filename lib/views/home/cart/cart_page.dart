import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/components/button.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late SharedPreferences prefs;
  List<Order> clientOrders = List.empty(growable: true);
  bool isLoading = true; // Variable para controlar la carga de datos

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await readFromSharedPreferences();
    setState(() {
      isLoading = false; // Indica que la carga ha terminado
    });
  }

  Future<void> readFromSharedPreferences() async {
    List<String>? orders = prefs.getStringList('orders');
    if (orders != null) {
      clientOrders = orders.map((order) {
        return Order.fromJson(jsonDecode(order));
      }).toList();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                    Order order = clientOrders[index];
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
                                  "Precio: ${order.price.toString()}\$",
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
                      onTap: () {},
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
