import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:test_graduation/core/constants/fcm_config.dart';

class FCMSenderService {
  final Dio _dio = Dio();

  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/firebase.messaging',
  ];

  Future<String> _getAccessToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(FCMConfig.serviceAccount),
      _scopes,
    );
    final accessToken = client.credentials.accessToken.data;
    client.close();
    return accessToken;
  }

  Future<void> sendPushNotification({
    required String title,
    required String body,
    String? token,
    String? topic,
    Map<String, dynamic>? data,
  }) async {
    try {
      final String accessToken = await _getAccessToken();
      
      final Map<String, dynamic> message = {
        'message': {
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            ...?data,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'general_channel',
              'sound': 'default',
            },
          },
          'apns': {
            'payload': {
              'aps': {
                'sound': 'default',
                'badge': 1,
              },
            },
          },
        }
      };

      if (token != null && token.isNotEmpty) {
        message['message']['token'] = token;
      } else {
        message['message']['topic'] = topic ?? 'all';
      }

      final response = await _dio.post(
        FCMConfig.fcmV1Url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        log('FCM Push Sent Successfully (v1): ${response.data}');
      } else {
        log('FCM Push Failed (v1): ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      log('Error sending FCM Push (v1): $e');
    }
  }
}
