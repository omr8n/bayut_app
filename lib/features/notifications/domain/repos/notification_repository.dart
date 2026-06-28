import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';

abstract class NotificationRepository {
  /// Sends a push notification and saves it to Firestore history
  Future<Either<Failure, Unit>> sendNotification(AppNotification notification);

  /// Streams user notifications from Firestore
  Stream<Either<Failure, List<AppNotification>>> getNotificationsStream(String userId);

  /// Streams all notifications for admin view
  Stream<Either<Failure, List<AppNotification>>> getAllNotificationsStream();

  /// Streams global notifications
  Stream<Either<Failure, List<AppNotification>>> getGlobalNotificationsStream();

  /// Marks a notification as seen
  Future<Either<Failure, Unit>> markAsSeen(String userId, String notificationId);
}
