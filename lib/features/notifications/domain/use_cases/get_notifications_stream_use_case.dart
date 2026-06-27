import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import '../repos/notification_repository.dart';

class GetNotificationsStreamUseCase {
  final NotificationRepository repository;

  GetNotificationsStreamUseCase(this.repository);

  Stream<Either<Failure, List<AppNotification>>> call(String userId) {
    return repository.getNotificationsStream(userId);
  }
}
