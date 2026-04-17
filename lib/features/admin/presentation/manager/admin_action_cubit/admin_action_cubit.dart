import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_action_repo.dart';
import 'admin_action_state.dart';

class AdminActionCubit extends Cubit<AdminActionState> {
  final AdminActionRepo _adminActionRepo;

  AdminActionCubit(this._adminActionRepo) : super(AdminActionInitial());

  Future<void> logAdminAction(AdminActionModel action) async {
    final result = await _adminActionRepo.logAction(action);
    result.fold(
      (failure) => emit(AdminActionFailure(failure.message)),
      (_) => null, // Logged successfully in background
    );
  }

  Future<void> fetchAdminActions() async {
    emit(AdminActionLoading());
    final result = await _adminActionRepo.getActions();
    result.fold(
      (failure) => emit(AdminActionFailure(failure.message)),
      (actions) => emit(AdminActionSuccess(actions)),
    );
  }
}
