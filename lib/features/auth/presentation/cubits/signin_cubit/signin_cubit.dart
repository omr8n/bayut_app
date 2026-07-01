import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/secure_storage_singleton.dart';
import '../../../domain/entites/user_entity.dart';
import '../../../domain/repos/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepo authRepo;

  SigninCubit(this.authRepo) : super(SigninInitial());

  Future<void> signin(String email, String password) async {
    emit(SigninLoading());

    Either<Failure, UserEntity> result = await authRepo
        .signinWithEmailAndPassword(email, password);

    result.fold((failure) => emit(SigninFailure(message: failure.message)), (
      userEntity,
    ) async {
      // التحقق من حالة الحظر (Banned)
      if (userEntity.status == 'banned') {
        emit(SigninFailure(message: LangKeys.bannedErrorMessage));
        return;
      }

      // 🔥 التحقق من حالة الحذف (Deleted)
      if (userEntity.status == 'deleted') {
        emit(
          SigninFailure(
            message:
                "عذراً، هذا الحساب تم حذفه نهائياً ولا يمكن استخدامه مجدداً.",
          ),
        );
        return;
      }

      await SecureStorage.setBool('isLoggedIn', true);

      // تحديث بيانات المستخدم في الكيوبيت العالمي فوراً
      getIt.get<ProfileCubit>().updateUser(userEntity);

      log("SigninCubit: Success for ${userEntity.email}.");
      emit(SigninSuccess(userEntity: userEntity));
    });
  }
}
