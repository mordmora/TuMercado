import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future _backgroundHandler(RemoteMessage message) async {}

  static Future _onMessageHandler(RemoteMessage message) async {}

  static _onMessageOpenedApp(RemoteMessage message) async {}

  static Future initialiseApp() async {
    await Firebase.initializeApp();
    messaging.requestPermission();
    token = await messaging.getToken();

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }
}
