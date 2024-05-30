import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/components/button.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order.dart';
import 'package:tu_mercado/models/send_order_model.dart';
import 'package:tu_mercado/providers/order_provider.dart';
import 'package:tu_mercado/utils.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  bool isLoading = true;
  late SharedPreferences prefs;
  String _response = "";
  List<ProductOrder> clientOrders = List.empty(growable: true);

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  Future<void> saveToSharedPreferences() async {
    List<String> orders =
        clientOrders.map((order) => jsonEncode(order.toJson())).toList();
    prefs.setStringList('orders', orders);
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await readFromSharedPreferences();
    setState(() {
      isLoading = false; // Indica que la carga ha terminado
    });
  }

  Future<void> readFromSharedPreferences() async {
    List<String>? orders = prefs.getStringList('orders');
    if (orders != null) {
      clientOrders = orders.map((order) {
        return ProductOrder.fromJson(jsonDecode(order));
      }).toList();
    }
  }

  double getTotalPrice() {
    double total = 0;
    for (ProductOrder order in clientOrders) {
      total += order.price;
    }
    return total;
  }

  void _launchMercadoPago() async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse('https://flutter.dev'),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Crear pedido',
          style: TextStyles.getTittleStyleWithSize(25),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nombre del titular", style: TextStyles.profileName),
              TextFormField(
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Nombre del titular',
                    hintStyle: TextStyles.hintStyle),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fecha de expiración',
                          style: TextStyles.profileName),
                      TextFormField(
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'MM/YY',
                          hintStyle: TextStyles.hintStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CVC', style: TextStyles.profileName),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          hintText: '***',
                          hintStyle: TextStyles.hintStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const Text("Numero de tarjeta", style: TextStyles.profileName),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  hintText: 'Numero de tarjeta',
                  hintStyle: TextStyles.hintStyle,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Vas a pedir:", style: TextStyles.profileName),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: clientOrders.length,
                  itemBuilder: (context, index) => RowInfo(
                    label:
                        "${clientOrders[index].name} x${clientOrders[index].quantity.toInt()}",
                    content: getFormatMoneyString(clientOrders[index].price),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 1,
                color: Colors.black,
              ),
              RowInfo(
                  label: 'Total',
                  content: getFormatMoneyString(getTotalPrice())),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Realizar pedido',
                color: Colors.black,
                labelColor: Colors.white,
                height: 55,
                width: double.infinity,
                onTap: () {
                  OrderData orderData = OrderData(
                    order: Order(value: getTotalPrice(), details: ""),
                    products: clientOrders,
                  );

                  Provider.of<OrderProvider>(context, listen: false)
                      .createNewOrder(orderData)
                      .then((value) => {
                            _response = value.link,
                          })
                      .whenComplete(() {
                    clientOrders.clear();
                    saveToSharedPreferences();
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(""),
                              content: Text(_response),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, "/home", (route) => false),
                                    child: const Text("Ok"))
                              ],
                            ));
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
