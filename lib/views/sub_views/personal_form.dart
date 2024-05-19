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
            formatter: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
            isPassword: false,
            controller: widget.nameController,
          ),
          const SizedBox(height: 20),
          const Text("Primer Apellido", style: TextStyles.subtitle),
          CustomTextField(
            formatter: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
            isPassword: false,
            controller: widget.lastNameController,
          ),
          const SizedBox(height: 20),
          const Text("Fecha de nacimiento", style: TextStyles.subtitle),
          CustomTextField(
            hintText: 'AAAA/MM/DD',
            onChanged: (value) {
              setState(() {});
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a date';
              }
              if (!_isValidDate(value)) {
                return 'Please enter a valid date';
              }
              return null;
            },
            formatter: [
              DateTextInputFormatter(),
            ],
            keyboardType: TextInputType.datetime,
            isPassword: false,
            controller: widget.dateController,
          ),
          _isValidDate(widget.dateController.text) == false
              ? const Text("Ingresa una fecha valida, por ejemplo 2000/01/01",
                  style: TextStyles.error)
              : const SizedBox(
                  height: 20,
                ),
          DropdownMenu(
            textStyle: TextStyles.normal,
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
            enableSearch: false,
            width: 140,
            menuStyle: const MenuStyle(
              backgroundColor: MaterialStatePropertyAll(Palette.green),
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

  bool _isValidDate(String value) {
    final dateRegex = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return false;
    }
    final parts = value.split('/');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    if (month < 1 || month > 12) {
      return false;
    }
    if (day < 1 || day > 31) {
      return false;
    }
    // Check for valid days in each month
    if (month == 2) {
      // Leap year check
      bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      if (day > (isLeapYear ? 29 : 28)) {
        return false;
      }
    } else if ([4, 6, 9, 11].contains(month) && day > 30) {
      return false;
    }
    return true;
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
