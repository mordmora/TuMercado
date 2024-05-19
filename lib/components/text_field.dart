import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final void Function(String)? onChanged;
  final bool isPassword;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatter;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hintText;
  const CustomTextField(
      {super.key,
      this.validator,
      this.hintText,
      this.onChanged,
      this.formatter,
      this.keyboardType,
      required this.controller,
      required this.isPassword});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? obscureText;
  @override
  void initState() {
    obscureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator ?? (value) => null,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.formatter,
      obscureText: widget.isPassword ? obscureText! : false,
      onChanged: widget.onChanged,
      controller: widget.controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          hintText: widget.hintText ?? '',
          hintStyle: const TextStyle(color: Colors.black),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText!;
                    });
                  },
                  icon: obscureText!
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Colors.black,
                        ))
              : null,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          )),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ))),
    );
  }
}
