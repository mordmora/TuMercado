import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tu_mercado/config/route_managment.dart';
import 'package:tu_mercado/providers/auth_provider.dart';
import 'package:tu_mercado/providers/order_provider.dart';
import 'package:tu_mercado/providers/product_provider.dart';
import 'package:tu_mercado/providers/user_data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'Outfit',
          ),
          child: const MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        ),
      ),
    );
  }
}
