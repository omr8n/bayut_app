import 'package:dartz/dartz.dart';

import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import '../repos/notification_repository.dart';

class GetCombinedNotificationsUseCase {
  final NotificationRepository repository;

  GetCombinedNotificationsUseCase(this.repository);

  Stream<Either<Failure, List<AppNotification>>> call(String userId) {
    // 🔥 تبسيط المنطق: مستودع الإشعارات يقوم بالفعل بجلب الإشعارات العامة والخاصة بالمستخدم معاً
    // مما يمنع التكرار الناتج عن دمج التدفقين بشكل يدوي.
    return repository.getNotificationsStream(userId).map((result) {
      return result.map((notifications) {
        // ترتيب تنازلي حسب التاريخ لضمان ظهور الأحدث أولاً
        final sorted = List<AppNotification>.from(notifications);
        sorted.sort((a, b) => b.sentAt.compareTo(a.sentAt));
        return sorted;
      });
    }).asBroadcastStream();
  }
}
