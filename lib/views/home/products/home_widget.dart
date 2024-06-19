import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/providers/auth_provider.dart';
import 'package:tu_mercado/providers/product_provider.dart';
import 'package:tu_mercado/views/home/products/product_details.dart';

import '../../../components/product_card.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late SharedPreferences prefs;
  late List<Product> products;
  late Future<List<Product>> fetchProducts;

  String _email = "";
  String _password = "";

  @override
  void initState() {
    //getSharedPreferences();
    super.initState();
    fetchProducts = ProductProvider().fetchProducts();
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _email = prefs.getString("email") ?? "";
    _password = prefs.getString("password") ?? "";
    AuthProvider()
        .login(_email, _password)
        .then((value) => {prefs.setString("token", value)})
        .whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              product: product,
                            ),
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
