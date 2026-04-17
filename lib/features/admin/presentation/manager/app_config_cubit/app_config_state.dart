import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/models/app_config_model.dart';

abstract class AppConfigState extends Equatable {
  const AppConfigState();
  @override
  List<Object?> get props => [];
}

class AppConfigInitial extends AppConfigState {}
class AppConfigLoading extends AppConfigState {}
class AppConfigSuccess extends AppConfigState {
  final AppConfigModel config;
  const AppConfigSuccess(this.config);
}
class AppConfigUpdateSuccess extends AppConfigState {}
class AppConfigFailure extends AppConfigState {
  final String errMessage;
  const AppConfigFailure(this.errMessage);
}
