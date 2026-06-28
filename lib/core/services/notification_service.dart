import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_graduation/core/models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // حفظ الإشعار في قاعدة البيانات ليظهر في السجل
  Future<void> saveNotification(AppNotification notification) async {
    await _firestore.collection('notifications').doc(notification.id).set({
      'title': notification.title,
      'body': notification.body,
      'type': notification.type.index,
      'sentToAll': notification.sentToAll,
      'sentAt': notification.sentAt.toIso8601String(),
      'recipientsCount': notification.recipientsCount,
      'targetUserId': notification.targetUserId,
      'targetId': notification.targetId, // 🔥 حفظ معرف الهدف
      'isRead': notification.isRead,
      'fcmToken': notification.fcmToken, // 🔥 هذا الحقل سيقوم بعمل Trigger للإضافة
    });
  }

  // جلب سجل الإشعارات لمستخدم معين أو الجميع (أو كل شيء للمسؤول)
  Stream<List<AppNotification>> getNotificationsStream(String? userId, {bool isAdmin = false}) {
    Query query = _firestore.collection('notifications');

    return query
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AppNotification(
          id: doc.id,
          title: data['title'] ?? '',
          body: data['body'] ?? '',
          type: NotificationType.values[data['type'] ?? 0],
          sentToAll: data['sentToAll'] ?? false,
          sentAt: DateTime.parse(data['sentAt'] ?? DateTime.now().toIso8601String()),
          recipientsCount: data['recipientsCount'] ?? 0,
          targetUserId: data['targetUserId'],
          targetId: data['targetId'], // 🔥 جلب معرف الهدف
          isRead: data['isRead'] ?? false,
        );
      }).where((notif) {
        if (isAdmin) return true; // المسؤول يرى كل شيء
        if (userId == null) return notif.sentToAll;
        return notif.sentToAll || notif.targetUserId == userId;
      }).toList();
    });
  }

  // تحديث حالة القراءة
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }
}
