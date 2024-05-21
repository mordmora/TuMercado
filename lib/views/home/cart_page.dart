import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isEmpty
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
          : const Text('Cart'),
    );
  }
}
