import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/repos/media_repo/media_repo.dart';
import '../../../domain/entites/user_entity.dart';
import '../../../domain/repos/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo authRepo;
  final MediaRepo mediaRepo;

  SignupCubit(this.authRepo, this.mediaRepo) : super(SignupInitial());

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phone, {
    XFile? imageFile,
  }) async {
    emit(SignupLoading());

    String? imageUrl;

    if (imageFile != null) {
      final uploadResult = await mediaRepo.uploadMedia(imageFile);
      bool uploadFailed = false;

      uploadResult.fold((failure) {
        uploadFailed = true;
        emit(SignupFailure(message: "فشل رفع الصورة: ${failure.message}"));
      }, (url) => imageUrl = url);

      if (uploadFailed) return;
    }

    final Either<Failure, UserEntity> result = await authRepo.signUp(
      email,
      password,
      name,
      phone,
      imageUrl,
      () => Timestamp.now(),
    );

    result.fold((failure) => emit(SignupFailure(message: failure.message)), (
      userEntity,
    ) async {
      // 🔥 حفظ الحالة وتحديث الكاش مع LOG
      await SecureStorage.setBool('isLoggedIn', true);
      log(
        "SignupCubit: Success for ${userEntity.email}. isLoggedIn set to true.",
      );
      emit(SignupSuccess(userEntity: userEntity));
    });
  }
}
