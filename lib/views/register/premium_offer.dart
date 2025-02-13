// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/providers/order_provider.dart';

class PremiumOffer extends StatelessWidget {
  final void Function() onPressed;
  final bool isActive;
  const PremiumOffer(
      {super.key, required this.onPressed, required this.isActive});

  void _openMercadoPago(BuildContext ctx) {
    String link = "";
    Provider.of<OrderProvider>(ctx, listen: false)
        .getMembershipLink()
        .then((value) {
      link = value;
    }).whenComplete(() {
      launchUrl(Uri.parse(link),
          customTabsOptions: const CustomTabsOptions(
            shareState: CustomTabsShareState.on,
          ));
    });
  }

  Widget _confirmationDialog(BuildContext ctx) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "¿Estas seguro de actualizar tu membresía?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Outfit', fontSize: 16),
              ),
              Row(children: [
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: Palette.greenDark,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Cancelar",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Outfit',
                            fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: Palette.greenDark,
                    onPressed: () {
                      _openMercadoPago(ctx);
                    },
                    child: const Text("Confirmar",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Outfit',
                            fontSize: 16)),
                  ),
                ),
              ])
            ],
          ),
        ));
  }

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
              isActive
                  ? const Text("¡Ya eres premium!", style: TextStyles.title)
                  : const Text("¡Hazte premium!", style: TextStyles.title),
              const SizedBox(height: 20),
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
                onPressed: isActive
                    ? null
                    : () {
                        showDialog(
                            context: context,
                            builder: (context) => _confirmationDialog(context));
                      },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.grey : Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text("Actualizar membresía",
                      style: TextStyles.subtitle.copyWith(color: Colors.white)),
                ),
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: onPressed,
                        child: Text(isActive ? "Volver" : "Omitir por ahora",
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
