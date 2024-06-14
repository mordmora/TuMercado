import 'package:flutter/material.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/models/order_response.dart';

class OrderCard extends StatelessWidget {
  final String title;
  final List<Products> products;

  const OrderCard({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Palette.green,
            ),
            child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return RowInfo(
                    label: products[index].name,
                    content: products[index].price.toString(),
                  );
                })),
      ],
    );
  }
}
