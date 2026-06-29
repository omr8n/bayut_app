import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/models/app_config_model.dart';

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();

  @override
  List<Object?> get props => [];
}

class AppSettingsInitial extends AppSettingsState {}

class AppSettingsLoading extends AppSettingsState {}

class AppSettingsLoaded extends AppSettingsState {
  final AppConfigModel config;
  const AppSettingsLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

class AppSettingsFailure extends AppSettingsState {
  final String errMessage;
  const AppSettingsFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class AppSettingsUpdateSuccess extends AppSettingsState {}
