import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/notifications/domain/use_cases/get_all_notifications_use_case.dart';

part 'admin_notification_state.dart';

class AdminNotificationCubit extends Cubit<AdminNotificationState> {
  final GetAllNotificationsUseCase _getAllNotificationsUseCase;
  final AdminCubit _adminCubit;
  StreamSubscription? _subscription;

  AdminNotificationCubit(this._getAllNotificationsUseCase, this._adminCubit)
      : super(AdminNotificationInitial());

  void fetchNotificationsHistory() {
    emit(AdminNotificationLoading());
    _subscription?.cancel();
    _subscription = _getAllNotificationsUseCase().listen((result) {
      result.fold(
        (failure) => emit(AdminNotificationFailure(failure.message)),
        (notifications) => emit(AdminNotificationSuccess(notifications)),
      );
    }, onError: (error) {
      emit(AdminNotificationFailure(error.toString()));
    });
  }

  Future<void> sendGlobalNotification(String title, String body) async {
    emit(AdminNotificationSendLoading());
    try {
      await _adminCubit.sendNotification(title, body);
      // AdminCubit handles the actual sending and logs.
      // We don't need a separate result because AdminCubit emits AdminActionSuccess.
      // However, to keep this clean, we listen to AdminCubit in the UI or handle results.
      emit(const AdminNotificationSendSuccess("Notification sent to all users"));
    } catch (e) {
      emit(AdminNotificationSendFailure(e.toString()));
    }
  }

  Future<void> sendTargetedNotification({
    required String uId,
    required String name,
    required String title,
    required String body,
    required NotificationType type,
  }) async {
    emit(AdminNotificationSendLoading());
    try {
      await _adminCubit.sendTargetedNotification(
        uId: uId,
        name: name,
        title: title,
        body: body,
        type: type,
      );
      emit(AdminNotificationSendSuccess("Notification sent to $name"));
    } catch (e) {
      emit(AdminNotificationSendFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
