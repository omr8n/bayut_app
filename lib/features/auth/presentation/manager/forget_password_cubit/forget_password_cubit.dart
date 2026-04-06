import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repos/auth_repo.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepo authRepo;
  ForgetPasswordCubit(this.authRepo) : super(ForgetPasswordInitial());

  Future<void> resetPassword(String email) async {
    emit(ForgetPasswordLoading());
    final result = await authRepo.resetPassword(email);
    result.fold(
      (failure) => emit(ForgetPasswordFailure(failure.message)),
      (_) => emit(ForgetPasswordSuccess()),
    );
  }
}
