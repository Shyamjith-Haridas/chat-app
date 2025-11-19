import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<dynamic> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
    );

    await _notifications.initialize(settings);
  }

  static Future showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'chat_channel',
          'Chat Messages',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
    );
  }
}
