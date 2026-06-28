part of 'admin_notification_cubit.dart';

abstract class AdminNotificationState extends Equatable {
  const AdminNotificationState();

  @override
  List<Object?> get props => [];
}

class AdminNotificationInitial extends AdminNotificationState {}

class AdminNotificationLoading extends AdminNotificationState {}

class AdminNotificationSuccess extends AdminNotificationState {
  final List<AppNotification> notifications;
  const AdminNotificationSuccess(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class AdminNotificationFailure extends AdminNotificationState {
  final String errMessage;
  const AdminNotificationFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class AdminNotificationSendLoading extends AdminNotificationState {}

class AdminNotificationSendSuccess extends AdminNotificationState {
  final String message;
  const AdminNotificationSendSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminNotificationSendFailure extends AdminNotificationState {
  final String errMessage;
  const AdminNotificationSendFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
