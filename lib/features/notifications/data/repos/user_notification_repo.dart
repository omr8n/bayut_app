import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/services/notification_service.dart';

class UserNotificationRepo {
  final NotificationService _notificationService;

  UserNotificationRepo(this._notificationService);

  Stream<Either<Failure, List<AppNotification>>> getNotifications(
    String userId,
  ) {
    try {
      return _notificationService
          .getNotificationsStream()
          .map(
            (notifications) =>
                right<Failure, List<AppNotification>>(notifications),
          );
    } catch (e) {
      return Stream.value(left(ServerFailure(e.toString())));
    }
  }

  Future<Either<Failure, Unit>> markAsSeen(
    String userId,
    String notificationId,
  ) async {
    try {
      // markAsSeen not yet implemented in service
      return right(unit);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
