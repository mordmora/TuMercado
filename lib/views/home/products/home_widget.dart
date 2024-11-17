import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:tu_mercado/providers/product_provider.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';
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
  late UserData usrData;
  bool hasMembership = false;
  bool hasFirstDiscount = false;
  bool hasUsedFirstDiscount = true;

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
    fetchProducts = ProductProvider().fetchProducts();
    usrData = Provider.of<UserProvider>(
            // ignore: use_build_context_synchronously
            context,
            listen: false)
        .userData;
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    hasFirstDiscount = usrData.membership.discount;
    hasMembership = usrData.membership.active;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Product>>(
          future: fetchProducts,
          builder: (contextBuilder, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ocurrió un arror: Revisa tu conección a internet o intenta reiniciar sesión, si el problema persiste, comunicate con soporte.',
                    style: TextStyles.normal,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.black),
                    ),
                    child: const Text(
                      "Cerrar sesión",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Outfit"),
                    ),
                  ),
                ],
              ));
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
                            disabledColor: Colors.grey,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    hasDiscount: hasFirstDiscount,
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              discount: hasFirstDiscount,
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
