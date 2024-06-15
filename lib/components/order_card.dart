import 'package:flutter/material.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order_response.dart';
import 'package:tu_mercado/utils.dart';

class OrderCard extends StatelessWidget {
  final ROrder order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          height: 175,
          width: MediaQuery.of(context).size.width,
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
              const Text(
                "..............................................................................................",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Outfit',
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  const Text("Precio: ",
                      style: TextStyle(
                          letterSpacing: 0,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Outfit')),
                  Text(getFormatMoneyString(order.value),
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
                  Text(order.products.length.toString(),
                      style: TextStyles.getTittleStyleWithSize(16))
                ],
              ),
              const SizedBox(height: 10),
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
                      style: TextStyles.getTittleStyleWithSize(18))
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
