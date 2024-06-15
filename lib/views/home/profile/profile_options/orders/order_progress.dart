import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tu_mercado/components/order_card.dart';
import 'package:tu_mercado/models/order_response.dart';
import 'package:tu_mercado/providers/order_provider.dart';
import 'package:tu_mercado/utils.dart';

class OrderProgress extends StatefulWidget {
  const OrderProgress({super.key});

  @override
  State<OrderProgress> createState() => _OrderProgressState();
}

class _OrderProgressState extends State<OrderProgress> {
  OrderResponse? orderResponse;
  List<ROrder> orders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mis pedidos"),
      ),
      body: Center(
          child: Container(
        child: FutureBuilder(
          future:
              Provider.of<OrderProvider>(context, listen: false).getOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Consumer<OrderProvider>(
                builder: (context, OrderProvider orderProvider, _) {
                  orderResponse = orderProvider.orderResponse;
                  return ListView.builder(
                    itemCount: orderResponse!.orders.length,
                    itemBuilder: (context, index) {
                      ROrder order = orderResponse!.orders[index];
                      return OrderCard(
                        order: order,
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      )),
    );
  }
}
