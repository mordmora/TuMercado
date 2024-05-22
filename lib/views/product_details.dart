import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/products.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String imagePath = "https://picsum.photos/400";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image(
                image: NetworkImage(imagePath),
                fit: BoxFit.fill,
              ),
              Text(widget.product.name, style: TextStyles.title),
              Text(widget.product.price.toString(),
                  style: TextStyles.productPrice),
              Card(
                elevation: 0,
                color: Colors.white,
                child: Container(
                  width: 100,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Cant. de productos",
                        labelStyle: TextStyles.subtitle),
                    keyboardType: TextInputType.number,
                  ),
                ),
              )
            ])),
      ),
    );
  }
}
