import 'package:equatable/equatable.dart';

// نموذج الإشعار
class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String? targetUserId; // إذا كان لمستخدم معين
  final bool sentToAll; // إذا كان لجميع المستخدمين
  final DateTime sentAt;
  final int recipientsCount; // عدد المستلمين

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.targetUserId,
    required this.sentToAll,
    required this.sentAt,
    required this.recipientsCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    type,
    targetUserId,
    sentToAll,
    sentAt,
    recipientsCount,
  ];
}

// أنواع الإشعارات
enum NotificationType {
  general, // عام
  warning, // تحذير
  promotion, // ترويج
  update, // تحديث
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
    }
  }
}
