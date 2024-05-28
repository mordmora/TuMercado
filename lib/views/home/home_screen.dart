import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/providers/auth_provider.dart';
import 'package:tu_mercado/views/home/cart/cart_page.dart';
import 'package:tu_mercado/views/home/profile/profile_page.dart';

import 'products/home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  String _email = "";
  String _password = "";
  String _token = "";

  late SharedPreferences prefs;

  List<Widget> pages = [
    const HomeWidget(),
    const CartPage(),
    const ProfilePage(),
  ];

  int _index = 0;
  bool _isLoading = true;

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _email = prefs.getString("email") ?? "";
    _password = prefs.getString("password") ?? "";
    AuthProvider().login(_email, _password).then((value) => {
          _token = value,
          prefs.setString("token", value),
          _isLoading = false,
          setState(() {
            print("Im here");
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    print("token loaded: " + _token);
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              unselectedItemColor: Colors.white,
              selectedItemColor: Palette.greenDark,
              enableFeedback: false,
              currentIndex: _index,
              onTap: (value) => setState(() {
                _index = value;
                _pageController.animateToPage(value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
                getSharedPreferences();
              }),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Inicio",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_rounded), label: "Carrito"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: "Perfil",
                ),
              ],
            ),
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "TuMercado",
                style: TextStyles.title,
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: SafeArea(
                child: PageView(
              controller: _pageController,
              onPageChanged: (value) => setState(() => _index = value),
              children: pages,
            )),
          );
  }
}
