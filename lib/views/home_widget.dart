import 'package:flutter/material.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/providers/product_provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late List<Product> products;

  Future<List<Product>> fetchProducts() async {
    products = await ProductProvider().fetchProducts();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: ProductProvider().fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;
            return products.isEmpty
                ? const Center(child: Text('No hay productos'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Text(product.name);
                    },
                  );
          }
        },
      ),
    );
  }
}
