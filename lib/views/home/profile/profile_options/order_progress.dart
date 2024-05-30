import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/models/send_order_model.dart';

class OrderProgress extends StatefulWidget {
  const OrderProgress({super.key});

  @override
  State<OrderProgress> createState() => _OrderProgressState();
}

class _OrderProgressState extends State<OrderProgress> {
  late SharedPreferences prefs;
  List<OrderData> orders = List.empty(growable: true);
  bool isLoading = true;

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await readCreatedOrders();
    setState(() {
      isLoading = false; // Indica que la carga ha terminado
    });
  }

  Future<void> saveOrderToSharedPreferences() async {
    List<String> saveOrder =
        orders.map((order) => jsonEncode(order.toJson())).toList();
    prefs.setStringList('createdOrders', saveOrder);
  }

  Future<void> readCreatedOrders() async {
    List<String>? createdOrders = prefs.getStringList('createdOrders');
    if (createdOrders != null) {
      orders = createdOrders.map((order) {
        return OrderData.fromJson(jsonDecode(order));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            body: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Palette.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        subtitle: Text(orders[index].order.value.toString()),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
