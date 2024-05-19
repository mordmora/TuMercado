import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tu_mercado/components/text_field.dart';
import 'package:tu_mercado/config/styles.dart';

class RecoveryAccount extends StatefulWidget {
  const RecoveryAccount({super.key});

  @override
  State<RecoveryAccount> createState() => _RecoveryAccountState();
}

class _RecoveryAccountState extends State<RecoveryAccount> {
  TextEditingController _emailController = TextEditingController();
  String _email = "";

  @override
  void initState() {
    _emailController.addListener(() {
      _email = _emailController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recuperar cuenta",
          style: TextStyles.title,
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text(
            "Ingresa tu correo para recuperar tu cuenta, si existe te llegará un código de recuperación.",
            style: TextStyles.normal,
          ),
          CustomTextField(controller: _emailController, isPassword: false),
          const SizedBox(height: 20),
          CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(context, '/recovery/confirm');
              },
              child: Container(
                width: 200,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              )),
        ]),
      )),
    );
  }
}
