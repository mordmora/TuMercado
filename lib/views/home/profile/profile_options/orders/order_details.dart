import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_mercado/components/row_info.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order_response.dart';
import 'package:tu_mercado/utils.dart';
import 'package:tu_mercado/views/home/profile/profile_options/orders/order_confirm.dart';

class OrderDetails extends StatefulWidget {
  final ROrder order;
  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
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
                  Text(getFormatMoneyString(widget.order.value),
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
                          price: getFormatMoneyString(widget.order.value),
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
                      onPressed: () {}),
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
