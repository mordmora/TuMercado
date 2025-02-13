import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/utils.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool discount;
  const ProductCard({super.key, required this.product, required this.discount});

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
        color: const Color.fromARGB(255, 236, 233, 233),
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
            padding: const EdgeInsets.only(left: 5, right: 5, top: 3),
            child: Text(
              widget.product.name,
              style: TextStyles.productTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 5),
            child: widget.discount
                ? Column(
                    children: [
                      Text(
                        getFormatMoneyString(widget.product.price),
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'Outfit',
                          letterSpacing: .2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        getFormatMoneyString(widget.product.price * (1 - 0.10)),
                        style: TextStyles.productPrice,
                      ),
                    ],
                  )
                : Text(
                    "${getFormatMoneyString(widget.product.price)}\$",
                    style: TextStyles.productPrice,
                  ),
          ),
        ],
      ),
    );
  }
}
