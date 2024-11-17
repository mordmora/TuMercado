import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tu_mercado/config/route_managment.dart';
import 'package:tu_mercado/firebase_options.dart';
import 'package:tu_mercado/providers/auth_provider.dart';
import 'package:tu_mercado/providers/order_provider.dart';
import 'package:tu_mercado/providers/product_provider.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
    name: 'tumercado-ecc4c',
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  String token = "";
  await messaging.getToken().then((value) {
    token = value!;
    print("FCM_TOK: $token");
    prefs.setString("deviceID", value);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print(message.data);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _appLinkSubscription;

  @override
  void initState() {
    initDeepLinks();
    super.initState();
  }

  @override
  void dispose() {
    _appLinkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    _appLinkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState?.pushNamed(uri.path);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'Outfit',
          ),
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'Tu Mercado',
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        ),
      ),
    );
  }
}
