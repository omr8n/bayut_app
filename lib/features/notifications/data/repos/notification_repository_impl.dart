import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/services/notification_service.dart';
import '../../domain/repos/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService _notificationService;

  NotificationRepositoryImpl(this._notificationService);

  @override
  Future<Either<Failure, Unit>> sendNotification(AppNotification notification) async {
    try {
      // Use existing saveNotification method
      await _notificationService.saveNotification(notification);

      return right(unit);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<AppNotification>>> getNotificationsStream(String userId) {
    return _notificationService.getNotificationsStream(userId).map(
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
