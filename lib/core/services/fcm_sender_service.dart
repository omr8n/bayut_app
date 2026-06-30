import 'dart:developer';
import 'package:dio/dio.dart';

class FCMSenderService {
  final Dio _dio = Dio();

  // TODO: Replace with your actual FCM Server Key (Legacy) or use OAuth2 for V1
  // For simplicity and immediate fix, we'll use a placeholder for the legacy key.
  // In a production app, this should be handled by a backend for security.
  static const String _serverKey = 'YOUR_LEGACY_SERVER_KEY_HERE';
  static const String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  Future<void> sendPushNotification({
    required String title,
    required String body,
    String? token,
    String? topic,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(
        _fcmUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey',
          },
        ),
        data: {
          'to': token ?? '/topics/${topic ?? 'all'}',
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            ...?data,
          },
          'priority': 'high',
        },
      );

      if (response.statusCode == 200) {
        log('FCM Push Sent Successfully: ${response.data}');
      } else {
        log('FCM Push Failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      log('Error sending FCM Push: $e');
    }
  }
}
