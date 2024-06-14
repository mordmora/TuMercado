import 'package:flutter/material.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/models/products.dart';

class OrderCard extends StatelessWidget {
  final String title;
  final List<Product> products;

  const OrderCard({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Palette.green,
        ),
        child: ListView.builder(itemBuilder: (context, index) {
          return RowInfo(
            label: products[index].name,
            content: products[index].price.toString(),
          );
        }));
  }
}
