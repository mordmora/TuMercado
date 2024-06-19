import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order_response.dart';
import 'package:tu_mercado/providers/order_provider.dart';
import 'package:tu_mercado/utils.dart';
import 'package:tu_mercado/views/home/profile/profile_options/orders/order_confirm.dart';

class OrderDetails extends StatefulWidget {
  final ROrder order;
  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  double getTotalPrice() {
    double total = 0;
    for (Products product in widget.order.products) {
      total += product.price * product.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.order.link);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del pedido", style: TextStyles.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Detalles del pedido", style: TextStyles.subtitle),
              Row(
                children: [
                  const Text("ID: ", style: TextStyles.subtitle),
                  Text(widget.order.id, style: TextStyles.subtitle),
                ],
              ),
              const SizedBox(height: 10),
              Container(color: Colors.black, height: 1),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, index) {
                    return RowInfo(
                        label: widget.order.products[index].name,
                        content:
                            "x${widget.order.products[index].amount} ${getFormatMoneyString((widget.order.products[index].price))}");
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(color: Colors.black, height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total: ", style: TextStyles.subtitle),
                  Text(getFormatMoneyString(getTotalPrice()),
                      style: TextStyles.subtitle),
                ],
              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Text(
                            "Confirmar pedido",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Outfit',
                                fontSize: 18),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Args args = Args(
                          link: widget.order.link,
                          price: getFormatMoneyString(getTotalPrice()),
                        );
                        Navigator.of(context).pushNamed(
                          '/order/confirm',
                          arguments: args,
                        );
                      }),
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Text(
                            "Cancelar pedido",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Outfit',
                                fontSize: 18),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Cancelar pedido",
                                    style:
                                        TextStyles.getTittleStyleWithSize(24)),
                                content: const Text(
                                  "¿Desea cancelar este pedido?",
                                  style: TextStyles.normal,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancelar")),
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .cancelOrder(widget.order.id)
                                            .then((value) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Cancelar pedido",
                                                    style: TextStyles
                                                        .getTittleStyleWithSize(
                                                            24),
                                                  ),
                                                  content: Text(
                                                    value,
                                                    style: TextStyles.normal,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () => Navigator
                                                            .pushNamedAndRemoveUntil(
                                                                context,
                                                                '/home',
                                                                (route) =>
                                                                    false),
                                                        child: Text("Ok"))
                                                  ],
                                                );
                                              });
                                        });
                                      },
                                      child: Text("Confirmar")),
                                ],
                              );
                            });
                      }),
                ],
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
