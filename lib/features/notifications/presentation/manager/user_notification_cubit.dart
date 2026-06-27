import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/models/notification_model.dart';

import 'package:test_graduation/features/notifications/domain/use_cases/get_combined_notifications_use_case.dart';

part 'user_notification_state.dart';

class UserNotificationCubit extends Cubit<UserNotificationState> {
  final GetCombinedNotificationsUseCase _getCombinedNotifications;
  StreamSubscription? _notificationsSubscription;

  UserNotificationCubit(this._getCombinedNotifications)
    : super(UserNotificationInitial());

  void getNotifications(String userId) {
    if (userId.isEmpty) return;

    emit(UserNotificationLoading());

    _notificationsSubscription?.cancel();

    _notificationsSubscription = _getCombinedNotifications(userId).listen(
      (result) {
        result.fold(
          (failure) => emit(UserNotificationFailure(failure.message)),
          (notifications) {
            emit(UserNotificationSuccess(notifications, 0));
          },
        );
      },
      onError: (error) {
        emit(UserNotificationFailure(error.toString()));
      },
    );
  }

  // Note: markAsSeen can also be moved to a UseCase if needed for strict adherence
  Future<void> markAsSeen(String userId, String notificationId) async {
    // Current implementation relies on Stream update,
    // but in strict Clean Arch, you'd call a MarkAsSeenUseCase
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
