import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/features/admin/domain/repos/app_config_repo.dart';
import 'app_config_state.dart';

class AppConfigCubit extends Cubit<AppConfigState> {
  final AppConfigRepo _appConfigRepo;

  AppConfigCubit(this._appConfigRepo) : super(AppConfigInitial());

  Future<void> fetchConfig() async {
    emit(AppConfigLoading());
    final result = await _appConfigRepo.getConfig();
    result.fold(
      (failure) => emit(AppConfigFailure(failure.message)),
      (config) => emit(AppConfigSuccess(config)),
    );
  }

  Future<void> updateConfig(AppConfigModel config) async {
    emit(AppConfigLoading());
    final result = await _appConfigRepo.updateConfig(config);
    result.fold((failure) => emit(AppConfigFailure(failure.message)), (_) {
      emit(AppConfigUpdateSuccess());
      fetchConfig();
    });
  }
}
