import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tu_mercado/components/text_field.dart';
import 'package:tu_mercado/config/styles.dart';

class ContactForm extends StatefulWidget {
  final TextEditingController numberController;
  final TextEditingController adressController;
  final List<TextInputFormatter>? filters;
  final void Function()? onTap;

  const ContactForm(
      {super.key,
      required this.onTap,
      this.filters,
      required this.numberController,
      required this.adressController});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  bool hasSelectedNeighborhood = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Numero de teléfono", style: TextStyles.subtitle),
      const SizedBox(height: 10),
      CustomTextField(
        formatter: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.deny(RegExp(r"\s")),
          LengthLimitingTextInputFormatter(10),
        ],
        isPassword: false,
        keyboardType: TextInputType.phone,
        controller: widget.numberController,
      ),
      const SizedBox(height: 20),
      const Text("Barrio", style: TextStyles.subtitle),
      DropdownButtonFormField(
          borderRadius: BorderRadius.circular(10.0),
          dropdownColor: Colors.green,
          decoration: const InputDecoration(
              focusColor: Colors.black,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              )),
          style: TextStyle(
              color: Colors.black, fontFamily: 'Outfit', fontSize: 16),
          items: const [
            DropdownMenuItem(
              value: "Casa",
              child: Text("Casa"),
            ),
            DropdownMenuItem(
              value: "Oficina",
              child: Text("Oficina"),
            ),
            DropdownMenuItem(
              value: "Trabajo",
              child: Text("Trabajo"),
            ),
          ],
          onChanged: (value) {
            setState(() {
              hasSelectedNeighborhood = true;
            });
          }),
      const SizedBox(height: 20),
      const Text("Dirección", style: TextStyles.subtitle),
      const SizedBox(height: 10),
      CustomTextField(
        formatter: widget.filters,
        isPassword: false,
        controller: widget.adressController,
      ),
      hasSelectedNeighborhood
          ? Text("En el barrio X el domicilio te cuesta: Y",
              style: TextStyles.normal)
          : const SizedBox(),
      Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: widget.onTap,
            child: Container(
                width: 100,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 80,
                )),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ]);
  }
}
