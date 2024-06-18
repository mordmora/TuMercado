import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:provider/provider.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';

class Args {
  final String price;
  final String link;
  Args({required this.price, required this.link});
}

class OrderConfirm extends StatefulWidget {
  final Args args;
  const OrderConfirm({super.key, required this.args});

  @override
  State<OrderConfirm> createState() => _OrderConfirmState();
}

class _OrderConfirmState extends State<OrderConfirm> {
  late UserData _userData;
  String price = "";
  String link = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    _userData = Provider.of<UserProvider>(context, listen: false).userData;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _launchMercadoPagoURL() async {
    String url = widget.args.link;
    launchUrl(Uri.parse(url),
        customTabsOptions: const CustomTabsOptions(
          shareState: CustomTabsShareState.on,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Detalles del pedido", style: TextStyles.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RowInfo(label: "Pagarás", content: widget.args.price),
                  RowInfo(
                      label: "Recibe",
                      content: "${_userData.firstName} ${_userData.lastName}"),
                  RowInfo(label: "Dirección", content: _userData.address),
                ],
              ),
              Column(
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Palette.green),
                          child: const Text(
                            "Pagar",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Outfit'),
                          )),
                      onPressed: () {
                        _launchMercadoPagoURL();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
