import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import '../repos/notification_repository.dart';

class GetCombinedNotificationsUseCase {
  final NotificationRepository repository;

  GetCombinedNotificationsUseCase(this.repository);

  Stream<Either<Failure, List<AppNotification>>> call(String userId) {
    // 🔥 تحديد الأنواع صراحة لـ Rx لضمان عدم حدوث Type Mismatch
    return Rx.combineLatest2<
        Either<Failure, List<AppNotification>>,
        Either<Failure, List<AppNotification>>,
        Either<Failure, List<AppNotification>>>(
      repository.getNotificationsStream(userId),
      repository.getGlobalNotificationsStream(),
      (userRes, globalRes) {
        return userRes.fold(
          (f) => Left(f),
          (userNotifs) => globalRes.fold(
            (f) => Left(f),
            (globalNotifs) {
              final combined = [...userNotifs, ...globalNotifs];
              // ترتيب تنازلي حسب التاريخ
              combined.sort((a, b) => b.sentAt.compareTo(a.sentAt));
              return Right(combined);
            },
          ),
        );
      },
    ).asBroadcastStream();
  }
}
