import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future _backgroundHandler(RemoteMessage message) async {
    print(message.messageId);
    print(message.data.toString());
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print("message.messageId : ${message.messageId}");

    print("message.data.toString() : ${message.data.toString()}");
    print("message.notification!.title : ${message.notification?.title}");
    print("message.notification!.body : ${message.notification?.body}");
  }

  static _onMessageOpenedApp(RemoteMessage message) async {
    print("message.messageId : ${message.messageId}");
    print("message.data.toString() : ${message.data.toString()}");
    print("message.notification!.title : ${message.notification!.title}");
    print("message.notification!.body : ${message.notification!.body}");
  }

  static Future initialiseApp() async {
    await Firebase.initializeApp();
    messaging.requestPermission();
    token = await messaging.getToken();
    print(token);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }
}
