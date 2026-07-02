import 'package:equatable/equatable.dart';

// أنواع الإشعارات
enum NotificationType {
  general, // عام
  warning, // تحذير
  promotion, // ترويج
  update, // تحديث
  adminAction, // إجراء إداري
  report, // بلاغ
  propertyFeatured, // تميز العقار
  accountStatus, // حالة الحساب
}

extension NotificationTypeExtension on NotificationType {
  String get arabicName {
    switch (this) {
      case NotificationType.general:
        return 'عام';
      case NotificationType.warning:
        return 'تحذير';
      case NotificationType.promotion:
        return 'ترويج';
      case NotificationType.update:
        return 'تحديث';
      case NotificationType.adminAction:
        return 'إجراء إداري';
      case NotificationType.report:
        return 'بلاغ';
      case NotificationType.propertyFeatured:
        return 'تميز العقار';
      case NotificationType.accountStatus:
        return 'حالة الحساب';
    }
  }
}

// نموذج الإشعار
class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String? targetUserId; // إذا كان لمستخدم معين
  final String? targetUserName; // اسم المستخدم المستهدف للواجهة
  final String? targetId; // 🔥 معرف الكائن المرتبط (مثل معرف العقار)
  final bool sentToAll; // إذا كان لجميع المستخدمين
  final DateTime sentAt;
  final int recipientsCount; // عدد المستلمين
  final bool isRead; // حالة القراءة
  final String? fcmToken; // 🔥 حقل إضافي لعمل Trigger لفايربيز
  final String? titleKey; // 🔥 مفتاح ترجمة العنوان
  final String? bodyKey; // 🔥 مفتاح ترجمة المحتوى
  final Map<String, dynamic>? bodyArgs; // 🔥 متغيرات الترجمة (مثل id أو title)

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.targetUserId,
    this.targetUserName,
    this.targetId,
    required this.sentToAll,
    required this.sentAt,
    required this.recipientsCount,
    this.isRead = false,
    this.fcmToken,
    this.titleKey,
    this.bodyKey,
    this.bodyArgs,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    String? targetUserId,
    String? targetUserName,
    String? targetId,
    bool? sentToAll,
    DateTime? sentAt,
    int? recipientsCount,
    bool? isRead,
    String? fcmToken,
    String? titleKey,
    String? bodyKey,
    Map<String, dynamic>? bodyArgs,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      targetUserId: targetUserId ?? this.targetUserId,
      targetUserName: targetUserName ?? this.targetUserName,
      targetId: targetId ?? this.targetId,
      sentToAll: sentToAll ?? this.sentToAll,
      sentAt: sentAt ?? this.sentAt,
      recipientsCount: recipientsCount ?? this.recipientsCount,
      isRead: isRead ?? this.isRead,
      fcmToken: fcmToken ?? this.fcmToken,
      titleKey: titleKey ?? this.titleKey,
      bodyKey: bodyKey ?? this.bodyKey,
      bodyArgs: bodyArgs ?? this.bodyArgs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        targetUserId,
        targetUserName,
        targetId,
        sentToAll,
        sentAt,
        recipientsCount,
        isRead,
        fcmToken,
        titleKey,
        bodyKey,
        bodyArgs,
      ];
}
