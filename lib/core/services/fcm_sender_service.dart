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
      log('🚀 Starting Final Type-Safe Fix for FCM Send...');
      final String accessToken = await _getAccessToken();

      // 1. بناء بيانات الـ Data بشكل صارم كنصوص فقط
      final Map<String, String> finalData = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'status': 'done',
      };

      if (data != null) {
        data.forEach((key, value) {
          finalData[key] = value.toString();
        });
      }

      // 2. بناء هيكل الرسالة النهائي بطريقة تمنع تعارض الأنواع (Strict Map Construction)
      final Map<String, dynamic> messageContent = {
        'notification': {
          'title': title,
          'body': body,
        },
        'data': finalData,
        'android': {
          'priority': 'HIGH',
          'direct_boot_ok': true,
          'notification': {
            'channel_id': 'general_channel',
            'sound': 'default',
            'notification_priority': 'PRIORITY_MAX',
            'visibility': 'PUBLIC',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
        },
        'apns': {
          'payload': {
            'aps': {
              'sound': 'default',
              'badge': 1,
              'content-available': 1,
            },
          },
        },
      };

      // إضافة التوكن أو الموضوع بشكل آمن (منع الإرسال للكل بالخطأ)
      if (token != null && token.isNotEmpty) {
        messageContent['token'] = token;
      } else if (topic != null && topic.isNotEmpty) {
        messageContent['topic'] = topic;
      } else {
        log('⚠️ SKIPPING Push Notification: Targeted user has no valid FCM token.');
        return;
      }

      final Map<String, dynamic> finalPayload = {
        'message': messageContent,
      };

      log('📤 Sending Safe Payload to Google...');

      final response = await _dio.post(
        FCMConfig.fcmV1Url,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => true,
        ),
        data: jsonEncode(finalPayload),
      );

      if (response.statusCode == 200) {
        log('✅ SUCCESS: Notification delivered to FCM');
      } else {
        log('❌ GOOGLE ERROR (${response.statusCode}): ${response.data}');
      }
    } catch (e, stack) {
      log('🛑 CRITICAL SENDER ERROR: $e');
      log('StackTrace: $stack');
    }
  }
}
