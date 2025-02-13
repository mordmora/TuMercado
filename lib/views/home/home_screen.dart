// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/models/user_data.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';
import 'package:tu_mercado/views/home/cart/cart_page.dart';
import 'package:tu_mercado/views/home/profile/profile_page.dart';
// ignore: library_prefixes

import 'products/home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  late UserData usrDt;

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
    super.initState();
    getSharedPreferences();
    //usrDt = Provider.of<UserProvider>(
    //       // ignore: use_build_context_synchronously
    //        context,
    //        listen: false)
    //    .userData;
    _pageController = PageController();
    _isLoading = false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await Provider.of<UserProvider>(context, listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "TuMercado",
                style: TextStyles.title,
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                SvgPicture.asset(
                  'lib/assets/bg.svg',
                  fit: BoxFit.fill,
                ),
                SafeArea(
                    child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _index = value;
                    });
                  },
                  children: pages,
                )),
              ],
            ),
          );
  }
}
