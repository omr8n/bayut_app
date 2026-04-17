import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';

abstract class AdminActionState extends Equatable {
  const AdminActionState();
  @override
  List<Object?> get props => [];
}

class AdminActionInitial extends AdminActionState {}
class AdminActionLoading extends AdminActionState {}
class AdminActionSuccess extends AdminActionState {
  final List<AdminActionModel> actions;
  const AdminActionSuccess(this.actions);
}
class AdminActionFailure extends AdminActionState {
  final String errMessage;
  const AdminActionFailure(this.errMessage);
}
