import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/utils.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String urlImage = "$BASE_URL/static/imgProducts/";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 223, 221, 221),
      ),
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  Image(image: NetworkImage(urlImage + widget.product.image))),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              widget.product.name,
              style: TextStyles.productTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 5),
            child: Text(
              "${getFormatMoneyString(widget.product.price)}\$",
              style: TextStyles.productPrice,
            ),
          ),
        ],
      ),
    );
  }
}
