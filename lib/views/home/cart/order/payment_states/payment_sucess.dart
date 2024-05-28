import 'package:flutter/material.dart';

class PaymentSucess extends StatelessWidget {
  const PaymentSucess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Text("Pago exitoso :D"),
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const Text("Gracias por tu compra"),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
                child: const Text("Volver"))
          ],
        ),
      ),
    );
  }
}
