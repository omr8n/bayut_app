import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/secure_storage_singleton.dart';
import '../../../domain/entites/user_entity.dart';
import '../../../domain/repos/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());
  final AuthRepo authRepo;

  Future<void> signin(String email, String password) async {
    emit(SigninLoading());

    Either<Failure, UserEntity> result = await authRepo
        .signinWithEmailAndPassword(email, password);
    result.fold((failure) => emit(SigninFailure(message: failure.message)), (
      userEntity,
    ) async {
      // 🔥 حفظ الحالة وتحديث الكاش مع LOG
      await SecureStorage.setBool('isLoggedIn', true);
      log(
        "SigninCubit: Success for ${userEntity.email}. isLoggedIn set to true.",
      );
      emit(SigninSuccess(userEntity: userEntity));
    });
  }
}
