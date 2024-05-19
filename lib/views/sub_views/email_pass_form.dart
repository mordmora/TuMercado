import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_mercado/components/text_field.dart';
import 'package:tu_mercado/config/styles.dart';

class EmailPassForm extends StatefulWidget {
  final void Function()? onTap;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  const EmailPassForm(
      {super.key,
      this.onTap,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});

  @override
  State<EmailPassForm> createState() => _EmailPassFormState();
}

class _EmailPassFormState extends State<EmailPassForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Email", style: TextStyles.subtitle),
          CustomTextField(
            controller: widget.emailController,
            isPassword: false,
          ),
          const SizedBox(height: 20),
          const Text("Contraseña", style: TextStyles.subtitle),
          CustomTextField(
            controller: widget.passwordController,
            isPassword: true,
          ),
          const SizedBox(height: 20),
          const Text("Confirmar contraseña", style: TextStyles.subtitle),
          CustomTextField(
            controller: widget.confirmPasswordController,
            isPassword: true,
          ),
          const SizedBox(height: 50),
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
}
