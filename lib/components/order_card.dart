// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/order_response.dart';

import 'package:tu_mercado/utils.dart';

@immutable
class OrderCard extends StatelessWidget {
  final ROrder order;

  const OrderCard({super.key, required this.order});

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
    if (x > 900) {
      return 0.33;
    } else if (x > 710) {
      return 0.35;
    } else if (x > 650) {
      return 0.36;
    } else {
      return 0.40;
    }
  }

  Color getColorsByStatus(String status) {
    if (status == "Pendiente") {
      return Colors.yellow.shade300;
    } else if (status == "Recogiendo tus productos")
      return Colors.orange.shade300;
    else if (status == "Enviado")
      return Colors.green;
    else if (status == "Pedido entregado")
      return Palette.green;
    else if (status == "Cancelado")
      return Colors.grey;
    else
      return Palette.green;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double heightRatio = getHeightRatio(height);
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
            color: getColorsByStatus(order.status),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("ID: #ORDER${order.id.substring(0, 5)}",
                          style: TextStyles.getTittleStyleWithSize(18)),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: order.id),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ID copiado al portapapeles'),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.copy_outlined,
                            size: 30,
                            color: Colors.black,
                          )),
                    ],
                  ),
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
                    onPressed: order.status == "Cancelado"
                        ? null
                        : () {
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
                          letterSpacing: -0.5)),
                ],
              ),
              SizedBox(height: height * 0.01),
              Container(
                color: Colors.grey,
                height: 1,
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Tiempo estimado de entrega: ${order.timeRange}",
                style: TextStyles.getTittleStyleWithSize(16),
              )
            ],
          ),
        )
      ],
    );
  }
}

class DetailButton extends StatelessWidget {
  final void Function()? onPressed;
  const DetailButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      disabledColor: Colors.grey,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text("Detalles",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Outfit', fontSize: 18))),
    );
  }
}
