import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import '../repos/notification_repository.dart';

class GetAllNotificationsUseCase {
  final NotificationRepository repository;

  GetAllNotificationsUseCase(this.repository);

  Stream<Either<Failure, List<AppNotification>>> call() {
    return repository.getAllNotificationsStream();
  }
}
