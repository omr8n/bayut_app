import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:flutter/material.dart';

/// معالج الإشعارات في الخلفية
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
  
  // تأكد من تهيئة Awesome Notifications في هذه المعزولة (Isolate) إذا لم تكن مهيأة
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'general_channel',
        channelName: 'إشعارات عامة',
        channelDescription: 'إشعارات الأخبار والتحديثات من التطبيق',
        defaultColor: AppColors.primary,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );

  _showBackgroundNotification(message);
}

void _showBackgroundNotification(RemoteMessage message) {
  if (message.notification != null) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'general_channel',
        title: message.notification!.title,
        body: message.notification!.body,
        notificationLayout: NotificationLayout.Default,
        payload: message.data.map((key, value) => MapEntry(key, value.toString())),
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
    // 1. طلب الإذن
    await _requestPermission();

    // 2. إعداد مستمعي Awesome Notifications
    _initAwesomeListeners();

    // 3. تعيين معالج الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 4. الاستماع للإشعارات والتطبيق مفتوح (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Message received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // 5. التعامل مع النقر على الإشعار والتطبيق في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification clicked in Background: ${message.data}");
      _handleNavigation(message.data);
    });

    // 6. التعامل مع النقر على الإشعار والتطبيق مغلق (Terminated)
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log("Notification clicked in Terminated state: ${initialMessage.data}");
      _handleNavigation(initialMessage.data);
    }

    // 7. الاشتراك في القناة العامة
    await _messaging.subscribeToTopic('all');

    // 8. طباعة التوكن
    String? token = await _messaging.getToken();
    log("FCM Token: $token");
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  void _initAwesomeListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    log("Awesome Notification Created");
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    log("Awesome Notification Displayed");
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    log("Awesome Notification Dismissed");
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    log("Awesome Notification Action Received: ${receivedAction.payload}");
    if (receivedAction.payload != null) {
      _handleNavigation(receivedAction.payload!);
    }
  }

  static void _showLocalNotification(RemoteMessage message) {
    if (message.notification != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: 'general_channel',
          title: message.notification!.title,
          body: message.notification!.body,
          notificationLayout: NotificationLayout.Default,
          payload: message.data.map((key, value) => MapEntry(key, value.toString())),
        ),
      );
    }
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    // نستخدم targetId للانتقال لتفاصيل العقار
    final String? targetId = data['targetId'];

    if (targetId != null && targetId.isNotEmpty) {
      log("Deep linking to Property: $targetId");
      RouterGenerationConfig.goRouter.pushNamed(
        AppRoutes.propertyDetailsById,
        pathParameters: {'id': targetId},
      );
    } else {
      log("Opening Notifications center");
      RouterGenerationConfig.goRouter.pushNamed(AppRoutes.notifications);
    }
  }
}
