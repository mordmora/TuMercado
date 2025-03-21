import 'package:flutter/material.dart';
import 'package:tu_mercado/alert.dart';
import 'package:tu_mercado/models/order_response.dart';
import 'package:tu_mercado/views/entrypoint.dart';
import 'package:tu_mercado/views/home/cart/order/payment_states/payment_failure.dart';
import 'package:tu_mercado/views/home/cart/order/payment_states/payment_sucess.dart';
import 'package:tu_mercado/views/home/home_screen.dart';
import 'package:tu_mercado/views/home/profile/profile_options/edit_profile.dart';
import 'package:tu_mercado/views/home/profile/profile_options/orders/order_confirm.dart';
import 'package:tu_mercado/views/home/profile/profile_options/orders/order_details.dart';
import 'package:tu_mercado/views/home/profile/profile_options/orders/my_orders.dart';
import 'package:tu_mercado/views/login/login.dart';
import 'package:tu_mercado/views/login/recovery.dart';
import 'package:tu_mercado/views/login/recovery_code.dart';
import 'package:tu_mercado/views/register/premium_offer.dart';
import 'package:tu_mercado/views/register/register.dart';

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
      case '/user/edit':
        return MaterialPageRoute(builder: (context) => const EditProfile());
      case '/user/my_orders':
        return MaterialPageRoute(builder: (context) => const OrderProgress());
      //case '/user/change_pwd':
      //  return MaterialPageRoute(builder: (context) => const ChangePassword());
      case '/payment/success':
        return MaterialPageRoute(builder: (context) => const PaymentSucess());
      case 'payment/failed':
        return MaterialPageRoute(builder: (context) => const PaymentFailure());
      case 'alert':
        return MaterialPageRoute(builder: (context) => const Alert());
      case '/premium_offer':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => PremiumOffer(
            onPressed: args['callback'] as void Function(),
            isActive: args['isActive'] as bool,
          ),
        );
      case '/order/details':
        return MaterialPageRoute(
            builder: (context) =>
                OrderDetails(order: settings.arguments as ROrder));
      case '/order/confirm':
        return MaterialPageRoute(
            builder: (context) => OrderConfirm(
                  args: settings.arguments as Args,
                ));
      default:
        return MaterialPageRoute(builder: (context) => const EntryPoint());
    }
  }
}
