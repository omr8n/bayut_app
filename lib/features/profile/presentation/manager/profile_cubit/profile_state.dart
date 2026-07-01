part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

// 🔥 حالة التحميل لتفعيل الـ Skeleton في الهيدر
class ProfileLoading extends ProfileState {}

// 🔥 حالة جديدة عند تحميل بيانات المستخدم
class ProfileUserLoaded extends ProfileState {
  final UserEntity user;
  const ProfileUserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileDarkModeToggled extends ProfileState {
  final bool isDarkMode;
  const ProfileDarkModeToggled(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}

class ProfileLogoutLoading extends ProfileState {}

class ProfileLogoutSuccess extends ProfileState {}

class ProfileUserBanned extends ProfileState {}

class ProfileUserDeleted extends ProfileState {}

class ProfileLogoutFailure extends ProfileState {
  final String errMessage;
  const ProfileLogoutFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}
