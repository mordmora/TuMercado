import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tu_mercado/components/text_field.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';

class PersonalForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController dateController;
  final void Function()? onTap;
  const PersonalForm(
      {super.key,
      required this.onTap,
      required this.nameController,
      required this.lastNameController,
      required this.dateController});

  @override
  State<PersonalForm> createState() => _PersonalFormState();
}

class _PersonalFormState extends State<PersonalForm> {
  String dropdownValue = 'Genero';
  String date = "";
  @override
  Widget build(BuildContext context) {
    List<String> items = ['Masculino', 'Femenino', 'Otro'];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Primer Nombre", style: TextStyles.subtitle),
          CustomTextField(
            formatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              FilteringTextInputFormatter.deny(RegExp(r"\s")),
              LengthLimitingTextInputFormatter(10),
            ],
            isPassword: false,
            controller: widget.nameController,
          ),
          const SizedBox(height: 20),
          const Text("Primer Apellido", style: TextStyles.subtitle),
          CustomTextField(
            formatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              FilteringTextInputFormatter.deny(RegExp(r"\s")),
              LengthLimitingTextInputFormatter(10),
            ],
            isPassword: false,
            controller: widget.lastNameController,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.dateController,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.black,
                  width: 2,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              )),
              labelStyle: TextStyle(color: Colors.black),
              label: Text("Fecha de nacimiento", style: TextStyles.subtitle),
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: _datePiker,
            readOnly: true,
          ),
          DropdownMenu(
            textStyle: TextStyles.normal,
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
            enableSearch: false,
            width: 140,
            menuStyle: const MenuStyle(
              backgroundColor: WidgetStatePropertyAll(Palette.green),
            ),
            hintText: "Género",
            dropdownMenuEntries: items
                .map((e) => DropdownMenuEntry(value: e, label: e))
                .toList(),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: SizedBox(
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
          )
        ]);
  }

  Future<void> _datePiker() async {
    final DateTime? picked = await showDatePicker(
      barrierColor: Colors.white,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        String text = picked.toString().split(' ')[0].replaceAll('-', '/');
        text.replaceAll('-', '/');
        widget.dateController.text = text;
      });
    }
  }
}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Prevent entering more than 10 characters
    if (text.length > 10) {
      return oldValue;
    }

    // Automatically insert '/' at correct positions
    var newText = text;
    if (text.length == 4 && oldValue.text.length < text.length) {
      newText = '$text/';
    } else if (text.length == 7 && oldValue.text.length < text.length) {
      newText = '$text/';
    }

    // Prevent entering more than 2 digits for month and day
    if (text.length > 5 &&
        text[4] != '/' &&
        (text.length == 6 || (text.length == 7 && text[6] != '/'))) {
      return oldValue;
    }
    if (text.length > 8 && text[7] != '/' && text.length == 9) {
      return oldValue;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
