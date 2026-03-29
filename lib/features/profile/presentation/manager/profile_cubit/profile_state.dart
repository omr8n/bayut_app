part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileDarkModeToggled extends ProfileState {
  final bool isDarkMode;
  const ProfileDarkModeToggled(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}

class ProfileLogoutLoading extends ProfileState {}

class ProfileLogoutSuccess extends ProfileState {}

class ProfileLogoutFailure extends ProfileState {
  final String errMessage;
  const ProfileLogoutFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}
