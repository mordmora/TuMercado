import 'package:flutter/material.dart';
import 'package:tu_mercado/config/styles.dart';

class EditAttribute extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final bool? editable;
  const EditAttribute(
      {super.key,
      required this.label,
      this.controller,
      this.editable});

  @override
  State<EditAttribute> createState() => _EditAttributeState();
}

class _EditAttributeState extends State<EditAttribute> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
        hintText: widget.label,
        hintStyle: TextStyles.profileName,
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
