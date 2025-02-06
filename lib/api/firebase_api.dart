import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shopswift/main.dart';

class FirebaseApi{
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications ()async{
    await firebaseMessaging.requestPermission();

    final fcMToken = await firebaseMessaging.getToken();

    print('token: $fcMToken');

    void handleMessages (RemoteMessage? message){
      if(message == null) {
        return;
      }
      navigatorKey.currentState?.pushNamed('/notifications', arguments: message);
    }

    Future initPushNotifications() async{
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.instance.getInitialMessage().then(handleMessages);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);

    }
    initPushNotifications();
  }
}