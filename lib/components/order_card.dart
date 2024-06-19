import 'package:flutter/material.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order_response.dart';

import 'package:tu_mercado/utils.dart';

@immutable
class OrderCard extends StatelessWidget {
  final ROrder order;

  OrderCard({super.key, required this.order});

  double getTotalPrice() {
    double total = 0;
    for (Products product in order.products) {
      total += product.price * product.amount;
    }
    return total;
  }

  int getQuantity() {
    int quantity = 0;
    for (Products product in order.products) {
      quantity += product.amount;
    }
    return quantity;
  }

  double getHeightRatio(double x) {
    if (x > 900)
      return 0.20;
    else if (x > 710)
      return 0.23;
    else if (x > 650)
      return 0.25;
    else
      return 0.27;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double heightRatio = getHeightRatio(height);
    print(height);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          width: width,
          height: height * heightRatio,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Palette.green,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ID: #ORDER${order.id.substring(0, 5)}",
                      style: TextStyles.getTittleStyleWithSize(18)),
                  Text(formatDate(order.createAt),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Outfit',
                          letterSpacing: BorderSide.strokeAlignInside))
                ],
              ),
              SizedBox(height: height * 0.01),
              Container(
                color: Colors.grey,
                height: 1,
              ),
              SizedBox(height: height * 0.01),
              Row(
                children: [
                  const Text("Total: ",
                      style: TextStyle(
                          letterSpacing: 0,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Outfit')),
                  Text(getFormatMoneyString(getTotalPrice()),
                      style: TextStyles.getTittleStyleWithSize(16))
                ],
              ),
              Row(
                children: [
                  const Text("Cantidad de productos: ",
                      style: TextStyle(
                          letterSpacing: 0,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Outfit')),
                  Text(getQuantity().toString(),
                      style: TextStyles.getTittleStyleWithSize(16))
                ],
              ),
              Row(
                children: [
                  const Text("Pagado: ",
                      style: TextStyle(
                          letterSpacing: 0,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Outfit')),
                  Text(
                    order.payment ? "Si" : "No",
                    style: TextStyle(
                        color: order.payment
                            ? const Color.fromARGB(255, 49, 182, 54)
                            : const Color.fromARGB(255, 214, 71, 61),
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DetailButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/order/details",
                          arguments: order);
                    },
                  ),
                  Text(order.status,
                      style: TextStyle(
                          color: order.status == "Cancelado"
                              ? const Color.fromARGB(255, 214, 71, 61)
                              : Colors.black,
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5))
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class DetailButton extends StatelessWidget {
  final void Function() onPressed;
  const DetailButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text("Detalles", style: TextStyles.normal),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
    );
  }
}
