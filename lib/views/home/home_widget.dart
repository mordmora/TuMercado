import 'package:flutter/material.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/providers/product_provider.dart';

import '../../components/product_card.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeWidgetState extends State<HomeWidget> {
  late List<Product> products;
  late Future<List<Product>> fetchProducts;

  @override
  void initState() {
    super.initState();
    fetchProducts = ProductProvider().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Product>>(
          future: fetchProducts,
          builder: (contextBuilder, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else {
              final products = snapshot.data!;
              return products.isEmpty
                  ? const Center(child: Text('No hay productos'))
                  : GridView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductCard(
                            product: product,
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .7, crossAxisCount: 2),
                    );
            }
          },
        ),
      ),
    );
  }
}
