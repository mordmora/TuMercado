import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tu_mercado/config/colors.dart';
import 'package:tu_mercado/config/styles.dart';
import 'package:tu_mercado/controllers/notification_controller.dart';
import 'package:tu_mercado/providers/auth_provider.dart';
import 'package:tu_mercado/views/home/cart/cart_page.dart';
import 'package:tu_mercado/views/home/profile/profile_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
    _timer = Timer.periodic(Duration(hours: 1), (timer) {
      getSharedPreferences();
    });
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod);
    initializeSocket();
    getSharedPreferences();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    AwesomeNotifications().dispose();
    socket.dispose();
    super.dispose();
    _timer.cancel();
  }

  void showNotification(dynamic data) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'New Message',
          body: data),
    );
  }

  late IO.Socket socket;
  late Timer _timer;

  void initializeSocket() {
    // Reemplaza con tu URL de servidor de Socket.IO
    socket = IO.io('ws://10.0.2.2:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('connect');
    });

    socket.on('mensaje_desde_servidor', (data) {
      showNotification(data);
    });

    socket.on('disconnect', (_) {
      print('disconnect');
    });
    print(socket.connected);
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
    print("token loaded: $_token");
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
              onPageChanged: (value) {
                setState(() {
                  _index = value;
                });
              },
              children: pages,
            )),
          );
  }
}
