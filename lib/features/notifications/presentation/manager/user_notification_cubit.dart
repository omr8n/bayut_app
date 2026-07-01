import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/features/notifications/domain/repos/notification_repository.dart';

import 'package:test_graduation/features/notifications/domain/use_cases/get_combined_notifications_use_case.dart';

part 'user_notification_state.dart';

class UserNotificationCubit extends Cubit<UserNotificationState> {
  final GetCombinedNotificationsUseCase _getCombinedNotifications;
  final NotificationRepository _repository;
  StreamSubscription? _notificationsSubscription;

  UserNotificationCubit(this._getCombinedNotifications, this._repository)
      : super(UserNotificationInitial());

  void getNotifications(String userId, {DateTime? accountCreatedAt}) {
    if (userId.isEmpty) return;

    emit(UserNotificationLoading());

    _notificationsSubscription?.cancel();

    _notificationsSubscription = _getCombinedNotifications(
      userId,
      accountCreatedAt: accountCreatedAt,
    ).listen(
      (result) {
        result.fold(
          (failure) => emit(UserNotificationFailure(failure.message)),
          (notifications) {
            final unreadCount = notifications.where((n) => !n.isRead).length;
            emit(UserNotificationSuccess(notifications, unreadCount));
          },
        );
      },
      onError: (error) {
        emit(UserNotificationFailure(error.toString()));
      },
    );
  }

  Future<void> markAsSeen(String userId, String notificationId) async {
    await _repository.markAsSeen(userId, notificationId);
  }

  Future<void> markAllAsRead(String userId) async {
    if (state is UserNotificationSuccess) {
      final notifications = (state as UserNotificationSuccess).notifications;
      for (var notif in notifications) {
        if (!notif.isRead) {
          await _repository.markAsSeen(userId, notif.id);
        }
      }
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
