import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:flutter/material.dart';

/// معالج الإشعارات في الخلفية - يجب أن يكون دالة علوية (Top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("🔥 Handling a background message: ${message.messageId}");
  
  // تهيئة Awesome Notifications للعمل في الـ Isolate الخاص بالخلفية
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'general_channel',
        channelName: 'إشعارات عامة',
        channelDescription: 'إشعارات الأخبار والتحديثات من التطبيق',
        defaultColor: AppColors.primary,
        ledColor: Colors.white,
        importance: NotificationImportance.Max, // أعلى أهمية للظهور فوراً
        channelShowBadge: true,
        defaultPrivacy: NotificationPrivacy.Public,
      ),
    ],
  );

  _showNotification(message);
}

void _showNotification(RemoteMessage message) {
  if (message.notification != null) {
    // 🔥 فحص العزل: التأكد من أن الإشعار مخصص للمستخدم الحالي (أو للكل)
    final String? targetUserId = message.data['targetUserId'];
    final bool sentToAll = message.data['sentToAll'] == 'true';
    final currentUser = FirebaseAuth.instance.currentUser;

    if (!sentToAll && targetUserId != null && currentUser != null) {
      if (targetUserId != currentUser.uid) {
        log("🛡️ FCM Service: Discarding notification intended for another user ($targetUserId)");
        return;
      }
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'general_channel',
        title: message.notification!.title,
        body: message.notification!.body,
        notificationLayout: NotificationLayout.Default,
        payload: message.data.map((key, value) => MapEntry(key, value.toString())),
        wakeUpScreen: true, // إيقاظ الشاشة
        category: NotificationCategory.Message,
      ),
    );
  }
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // 1. طلب الإذن (أساسي)
    await _requestPermission();

    // 2. تعيين معالج الخلفية قبل أي شيء
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. تحديث التوكن في السيرفر (Firestore)
    await updateTokenInFirestore();

    // 4. الاستماع لتغييرات التوكن
    _messaging.onTokenRefresh.listen((newToken) {
      log("🔄 FCM Token Refreshed: $newToken");
      _saveTokenToFirestore(newToken);
    });

    // 5. الاستماع للإشعارات والتطبيق مفتوح (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("📱 Foreground Message: ${message.notification?.title}");
      _showNotification(message);
    });

    // 6. التعامل مع النقر (خلفية / مغلق)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message.data);
    });

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data);
    }

    // 7. التأكد من الاشتراك في القناة العامة (سيتم التعامل معه عند تسجيل الدخول)
    // await _messaging.subscribeToTopic('all');
    // log("✅ Subscribed to 'all' topic");

    _initAwesomeListeners();
  }

  Future<void> subscribeToAllTopic() async {
    await _messaging.subscribeToTopic('all');
    log("✅ Subscribed to 'all' topic");
  }

  Future<void> unsubscribeFromAllTopic() async {
    await _messaging.unsubscribeFromTopic('all');
    log("🚫 Unsubscribed from 'all' topic");
  }

  Future<void> updateTokenInFirestore() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        log("🔑 Current FCM Token: $token");
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      log("❌ Error getting token: $e");
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'fcmToken': token})
          .then((_) => log("💾 Token saved to Firestore for user: ${user.uid}"))
          .catchError((e) => log("⚠️ Failed to save token: $e"));
    }
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    log("User granted permission: ${settings.authorizationStatus}");

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  void _initAwesomeListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.payload != null) {
      _handleNavigation(receivedAction.payload!);
    }
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    final String? targetId = data['targetId'];
    if (targetId != null && targetId.isNotEmpty) {
      RouterGenerationConfig.goRouter.pushNamed(
        AppRoutes.propertyDetailsById,
        pathParameters: {'id': targetId},
      );
    } else {
      RouterGenerationConfig.goRouter.pushNamed(AppRoutes.notifications);
    }
  }
}
