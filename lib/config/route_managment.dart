import 'package:flutter/material.dart';
import 'package:tu_mercado/views/entrypoint.dart';
import 'package:tu_mercado/views/home/home_screen.dart';
import 'package:tu_mercado/views/login.dart';
import 'package:tu_mercado/views/recovery.dart';
import 'package:tu_mercado/views/recovery_code.dart';
import 'package:tu_mercado/views/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const EntryPoint());
      case '/login':
        return MaterialPageRoute(builder: (context) => const Login());
      case '/register':
        return MaterialPageRoute(builder: (context) => const Register());
      case '/recovery':
        return MaterialPageRoute(builder: (context) => const RecoveryAccount());
      case '/recovery/confirm':
        return MaterialPageRoute(builder: (context) => const RecoveryCode());
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (context) => const EntryPoint());
    }
  }
}
