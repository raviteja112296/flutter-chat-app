import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//   static final _localNotifications = FlutterLocalNotificationsPlugin();

//   /// 🔹 Background handler
//   static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
//     debugPrint('🔔 Background message: ${message.notification?.title}');
//   }

//   /// 🔹 Initialize notifications
//   static Future<void> init() async {
//     // Permission (Android 13+)
//     await _firebaseMessaging.requestPermission();

//     // Token (VERY IMPORTANT)
//     final token = await _firebaseMessaging.getToken();
//     debugPrint('📱 FCM Token: $token');

//     // Android settings
//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const initSettings =
//         InitializationSettings(android: androidSettings);

//     await _localNotifications.initialize(initSettings);

//     // Foreground message
//     FirebaseMessaging.onMessage.listen(showNotification);

//     // Background handler
//     FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
//   }

//   /// 🔹 Show notification
//   static void showNotification(RemoteMessage message) {
//     final notification = message.notification;
//     if (notification == null) return;

//     const androidDetails = AndroidNotificationDetails(
//       'high_importance_channel',
//       'Chat Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const details = NotificationDetails(android: androidDetails);

//     _localNotifications.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       details,
//     );
//   }
// }
