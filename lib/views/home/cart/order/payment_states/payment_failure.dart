import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/styles.dart';

class PaymentFailure extends StatefulWidget {
  const PaymentFailure({super.key});

  @override
  State<PaymentFailure> createState() => _PaymentFailureState();
}

class _PaymentFailureState extends State<PaymentFailure> {
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
              const Icon(Icons.cancel, color: Colors.red, size: 100),
              const Text("Tu pago fue rechazado", style: TextStyles.title),
              TextButton(
                  onPressed: () {
                    unauthorized_access_attempt()
                        ? Navigator.pushNamedAndRemoveUntil(
                            context, '/alert', (route) => false) 
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
