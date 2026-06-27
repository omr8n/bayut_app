import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/services/operation_logger.dart';
import 'package:test_graduation/features/admin/domain/entities/admin_settings_entity.dart';
import 'package:test_graduation/features/admin/domain/use_cases/get_admin_settings_use_case.dart';
import 'package:test_graduation/features/admin/domain/use_cases/update_admin_settings_use_case.dart';
import 'admin_settings_state.dart';

class AdminSettingsCubit extends Cubit<AdminSettingsState> {
  final GetAdminSettingsUseCase getAdminSettingsUseCase;
  final UpdateAdminSettingsUseCase updateAdminSettingsUseCase;
  final OperationLogger operationLogger;

  AdminSettingsCubit({
    required this.getAdminSettingsUseCase,
    required this.updateAdminSettingsUseCase,
    required this.operationLogger,
  }) : super(AdminSettingsInitial());

  AdminSettingsEntity? currentSettings;

  Future<void> fetchSettings() async {
    emit(AdminSettingsLoading());
    final result = await getAdminSettingsUseCase();
    result.fold(
      (failure) => emit(AdminSettingsFailure(failure.message)),
      (settings) {
        currentSettings = settings;
        emit(AdminSettingsSuccess(settings));
      },
    );
  }

  Future<void> updateSettings(
    AdminSettingsEntity settings, {
    String? actionKey,
    Map<String, dynamic>? extraData,
  }) async {
    emit(AdminSettingsLoading());
    final result = await updateAdminSettingsUseCase(settings);
    result.fold(
      (failure) => emit(AdminSettingsFailure(failure.message)),
      (_) {
        if (actionKey != null) {
          operationLogger.logAdminAction(
            actionKey,
            {
              'new_settings': settings.props.toString(),
              ...?extraData,
            },
          );
        }

        currentSettings = settings;
        emit(AdminSettingsUpdateSuccess());
        emit(AdminSettingsSuccess(settings));
      },
    );
  }

  void toggleMaintenanceMode(bool value) {
    if (currentSettings != null) {
      final newSettings = currentSettings!.copyWith(maintenanceMode: value);
      updateSettings(
        newSettings,
        actionKey: 'MAINTENANCE_TOGGLE',
        extraData: {'status': value ? 'enabled' : 'disabled'},
      );
    }
  }
}
