part of 'user_notification_cubit.dart';

abstract class UserNotificationState extends Equatable {
  const UserNotificationState();

  @override
  List<Object?> get props => [];
}

class UserNotificationInitial extends UserNotificationState {}

class UserNotificationLoading extends UserNotificationState {}

class UserNotificationSuccess extends UserNotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;

  const UserNotificationSuccess(this.notifications, this.unreadCount);

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class UserNotificationFailure extends UserNotificationState {
  final String message;

  const UserNotificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
