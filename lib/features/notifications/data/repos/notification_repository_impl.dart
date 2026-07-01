import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/services/fcm_sender_service.dart';
import 'package:test_graduation/core/services/notification_service.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import '../../domain/repos/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService _notificationService;

  NotificationRepositoryImpl(this._notificationService);

  @override
  Future<Either<Failure, Unit>> sendNotification(AppNotification notification) async {
    try {
      // 1. Save to Firestore (for history)
      await _notificationService.saveNotification(notification);

      // 2. Trigger Real Push Notification via FCM
      // We restore this because relying on server extensions might be unreliable
      await getIt<FCMSenderService>().sendPushNotification(
        title: notification.title,
        body: notification.body,
        token: notification.sentToAll ? null : notification.fcmToken,
        topic: notification.sentToAll ? 'all' : null,
        data: {
          'targetId': notification.targetId ?? '',
          'type': notification.type.name,
          'targetUserId': notification.targetUserId ?? '', // Added for isolation filter
          'sentToAll': notification.sentToAll.toString(),
        },
      );

      return right(unit);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<AppNotification>>> getNotificationsStream(
    String userId, {
    DateTime? accountCreatedAt,
  }) {
    return _notificationService
        .getNotificationsStream(userId, accountCreatedAt: accountCreatedAt)
        .map((list) => right<Failure, List<AppNotification>>(list));
  }

  @override
  Stream<Either<Failure, List<AppNotification>>> getAllNotificationsStream() {
    return _notificationService.getNotificationsStream(null, isAdmin: true).map(
      (list) => right<Failure, List<AppNotification>>(list),
    );
  }

  @override
  Stream<Either<Failure, List<AppNotification>>> getGlobalNotificationsStream() {
    return _notificationService.getNotificationsStream(null).map(
      (list) => right<Failure, List<AppNotification>>(list),
    );
  }

  @override
  Future<Either<Failure, Unit>> markAsSeen(String userId, String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      return right(unit);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
