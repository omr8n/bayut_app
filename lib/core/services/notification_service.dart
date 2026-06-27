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
      'isRead': notification.isRead,
    });
  }

  // جلب سجل الإشعارات لمستخدم معين أو الجميع
  Stream<List<AppNotification>> getNotificationsStream(String? userId) {
    Query query = _firestore.collection('notifications');

    // إذا كان userId موجود، نجلب الإشعارات العامة + الإشعارات الموجهة له
    // ملاحظة: Firestore لا يدعم OR بسهولة في النسخ القديمة، لكننا سنفترض أننا نريد كل الإشعارات
    // التي تخصه أو العامة. للتبسيط حالياً سنجلب الكل ونفلتر أو نستخدم query مناسب.

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
          isRead: data['isRead'] ?? false,
        );
      }).where((notif) {
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
