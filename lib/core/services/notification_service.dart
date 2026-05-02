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
    });
  }

  // جلب سجل الإشعارات
  Stream<List<AppNotification>> getNotificationsStream() {
    return _firestore
        .collection('notifications')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AppNotification(
          id: doc.id,
          title: data['title'],
          body: data['body'],
          type: NotificationType.values[data['type']],
          sentToAll: data['sentToAll'],
          sentAt: DateTime.parse(data['sentAt']),
          recipientsCount: data['recipientsCount'],
          targetUserId: data['targetUserId'],
        );
      }).toList();
    });
  }
}
