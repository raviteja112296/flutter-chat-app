import 'dart:convert';
import 'package:http/http.dart' as http;

class FCMSender {
  static const String _serverKey =
      'YOUR_SERVER_KEY_FROM_FIREBASE_CONSOLE';

  static Future<void> send({
    required String token,
    required String title,
    required String body,
  }) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
      body: jsonEncode({
        'to': token,
        'notification': {
          'title': title,
          'body': body,
        },
      }),
    );
  }
}
