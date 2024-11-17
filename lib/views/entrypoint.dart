import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';
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
    await Provider.of<UserProvider>(context, listen: false).getUserData();
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
