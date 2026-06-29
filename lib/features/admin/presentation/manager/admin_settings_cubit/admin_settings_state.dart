import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/models/app_config_model.dart';

abstract class AdminSettingsState extends Equatable {
  const AdminSettingsState();

  @override
  List<Object?> get props => [];
}

class AdminSettingsInitial extends AdminSettingsState {}

class AdminSettingsLoading extends AdminSettingsState {}

class AdminSettingsLoaded extends AdminSettingsState {
  final AppConfigModel config;
  const AdminSettingsLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

class AdminSettingsFailure extends AdminSettingsState {
  final String errMessage;
  const AdminSettingsFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class AdminSettingsUpdateSuccess extends AdminSettingsState {}
