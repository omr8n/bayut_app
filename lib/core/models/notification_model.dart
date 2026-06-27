import 'package:equatable/equatable.dart';

// أنواع الإشعارات
enum NotificationType {
  general, // عام
  warning, // تحذير
  promotion, // ترويج
  update, // تحديث
  adminAction, // إجراء إداري
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
  final bool sentToAll; // إذا كان لجميع المستخدمين
  final DateTime sentAt;
  final int recipientsCount; // عدد المستلمين
  final bool isRead; // حالة القراءة

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.targetUserId,
    required this.sentToAll,
    required this.sentAt,
    required this.recipientsCount,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    String? targetUserId,
    bool? sentToAll,
    DateTime? sentAt,
    int? recipientsCount,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      targetUserId: targetUserId ?? this.targetUserId,
      sentToAll: sentToAll ?? this.sentToAll,
      sentAt: sentAt ?? this.sentAt,
      recipientsCount: recipientsCount ?? this.recipientsCount,
      isRead: isRead ?? this.isRead,
    );
  }

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
        isRead,
      ];
}
