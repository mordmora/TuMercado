import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/views/home/home_screen.dart';
import 'package:tu_mercado/views/login/login.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool rememberMe = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool("rememberMe") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(child: rememberMe ? const HomeScreen() : const Login()),
    );
  }
}
