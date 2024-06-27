import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';

class PremiumOffer extends StatelessWidget {
  final void Function() onPressed;
  const PremiumOffer({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  "lib/assets/logo_svg.svg",
                  color: Palette.greenDark,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
              const Text(
                  "Actualiza tu membresía y obten los siguientes beneficios:",
                  style: TextStyles.subtitle),
              const SizedBox(height: 20),
              const Text(
                "     - 10% de descuento en tu primer pedido",
                style: TextStyles.normal,
              ),
              const Text(
                "     - Domicilios gratis",
                style: TextStyles.normal,
              ),
              const Text("     - Pedidos prioritarios",
                  style: TextStyles.normal),
              const Text("     - Promociones frecuentes",
                  style: TextStyles.normal),
              const Expanded(child: SizedBox()),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text("Actualizar membresía",
                      style: TextStyles.subtitle.copyWith(color: Colors.white)),
                ),
                onPressed: () {},
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: onPressed,
                        child: Text("Omitir por ahora",
                            style: TextStyles.normal
                                .copyWith(color: Colors.grey))),
                  ),
                  Positioned(
                    right: 125,
                    bottom: 10,
                    left: 125,
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * 0.15,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
