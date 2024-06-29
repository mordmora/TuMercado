import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order.dart';
import 'package:tu_mercado/models/products.dart';
import 'package:tu_mercado/utils.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String imagePath = BASE_URL + "/static/imgProducts/";
  TextEditingController quantityController = TextEditingController();
  int quantity = 1;
  bool isValidQuantity = true;
  double _newPrice = 0;
  String _formatedNewPrice = "";
  late SharedPreferences prefs;

  List<ProductOrder> clientOrders = List.empty(growable: true);

  @override
  void initState() {
    getSharedPreferences();
    _newPrice = widget.product.price;
    super.initState();
    quantityController.text = quantity.toString();
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    readFromSharedPreferences();
  }

  void readFromSharedPreferences() async {
    List<String>? orders = prefs.getStringList('orders');
    if (orders != null) {
      clientOrders = orders.map((order) {
        return ProductOrder.fromJson(jsonDecode(order));
      }).toList();
    }
  }

  void saveToSharedPreferences() async {
    List<String> orders =
        clientOrders.map((order) => jsonEncode(order.toJson())).toList();
    prefs.setStringList('orders', orders);
  }

  void onQuantityChanged(String value) {
    setState(() {
      if (value.isEmpty || value == "0") {
        isValidQuantity = false;
      } else {
        isValidQuantity = true;
        quantity = int.parse(value);
        _newPrice = widget.product.price * quantity;
        _formatedNewPrice = getFormatMoneyString(_newPrice);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          scrollDirection: Axis.vertical,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: NetworkImage(imagePath + widget.product.image),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text(widget.product.name, style: TextStyles.title),
                      Text(
                          quantityController.text.isEmpty ||
                                  quantity == 0 ||
                                  quantity == 1
                              ? "${getFormatMoneyString(widget.product.price)}\$"
                              : "$_formatedNewPrice\$",
                          style: TextStyles.productPrice),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(5),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: quantityController,
                          onChanged: onQuantityChanged,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: isValidQuantity
                                        ? Colors.black
                                        : Colors.red,
                                  )),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              labelText: "Cantidad",
                              labelStyle: TextStyles.subtitle),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.21),
                      CupertinoButton(
                        disabledColor: Colors.grey,
                        padding: EdgeInsets.zero,
                        onPressed: isValidQuantity
                            ? () {
                                clientOrders.add(ProductOrder(
                                  description: widget.product.description,
                                  id: widget.product.id,
                                  name: widget.product.name,
                                  quantity: quantity,
                                  price: widget.product.price,
                                ));
                                saveToSharedPreferences();

                                Navigator.pop(context);
                              }
                            : null,
                        child: Container(
                            height: 55,
                            width: double.infinity,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isValidQuantity
                                    ? Colors.black
                                    : Colors.grey,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Agregar al carrito",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.shopping_cart, color: Colors.white),
                              ],
                            )),
                      )
                    ]),
              )),
        ),
      ),
    );
  }
}

