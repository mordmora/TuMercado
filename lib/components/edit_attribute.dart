import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tu_mercado/config/styles.dart';

class EditAttribute extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatter;
  final bool? editable;
  const EditAttribute(
      {super.key,
      required this.label,
      this.controller,
      this.editable,
      this.keyboardType,
      this.formatter});

  @override
  State<EditAttribute> createState() => _EditAttributeState();
}

class _EditAttributeState extends State<EditAttribute> {
  bool editable() {
    return widget.editable ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      inputFormatters: widget.formatter,
      controller: widget.controller,
      style: TextStyles.profileName,
      enabled: widget.editable ?? true,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
        labelStyle: TextStyles.profileName,
        counterStyle: TextStyles.profileName,
        prefixStyle: TextStyles.profileName,
        hintText: widget.label,
        hintStyle: TextStyles.profileName,
        suffixStyle: TextStyles.profileName,
        suffixIcon: (widget.editable ?? true)
            ? const Icon(Icons.edit, color: Colors.black)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
      ),
    );
  }
}
