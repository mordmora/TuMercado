import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/styles.dart';

class PaymentSucess extends StatefulWidget {
  const PaymentSucess({super.key});

  @override
  State<PaymentSucess> createState() => _PaymentSucessState();
}

class _PaymentSucessState extends State<PaymentSucess> {
  late SharedPreferences prefs;
  String _password = "";
  String _email = "";

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  void readFromSharedPreferences() async {
    setState(() {
      _password = prefs.getString("password") ?? "";
      _email = prefs.getString("email") ?? "";
    });
  }

  bool unauthorized_access_attempt() {
    return _password == "" || _email == "";
  }

  void getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    readFromSharedPreferences();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget alert() {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "No sabemos como llegaste aquí, pero no deberias estar en este lugar",
              style: TextStyles.subtitle),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: const Text("Volver"))
        ],
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    print(_password);
    print(_email);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const Text("Gracias por tu compra", style: TextStyles.title),
              TextButton(
                  onPressed: () {
                    unauthorized_access_attempt()
                        ? Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/alert',
                            (route) => false,
                          )
                        : Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                  },
                  child: const Text("Volver", style: TextStyles.subtitle))
            ],
          ),
        ),
      ),
    );
  }
}
