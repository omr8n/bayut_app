import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminStatsSuccess extends AdminState {
  final AdminStats stats;
  const AdminStatsSuccess(this.stats);

  @override
  List<Object?> get props => [stats];
}

class AdminUsersSuccess extends AdminState {
  final List<UserEntity> users;
  final bool hasReachedMax;
  final String? message; // 🔥 رسالة لنجاح عملية (مثل الحظر أو الحذف)
  const AdminUsersSuccess(this.users, {this.hasReachedMax = false, this.message});

  @override
  List<Object?> get props => [users, hasReachedMax, message];
}

class AdminPropertiesSuccess extends AdminState {
  final List<PropertyEntity> properties;
  final bool hasReachedMax;
  final String? message;
  const AdminPropertiesSuccess(this.properties, {this.hasReachedMax = false, this.message});

  @override
  List<Object?> get props => [properties, hasReachedMax, message];
}

class AdminActionSuccess extends AdminState {
  final String message;
  const AdminActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminFailure extends AdminState {
  final String errMessage;
  const AdminFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class AdminReportsSuccess extends AdminState {
  final List<ReportEntity> reports;
  final bool hasReachedMax;
  final String? message;
  const AdminReportsSuccess(this.reports, {this.hasReachedMax = false, this.message});

  @override
  List<Object?> get props => [reports, hasReachedMax, message];
}
