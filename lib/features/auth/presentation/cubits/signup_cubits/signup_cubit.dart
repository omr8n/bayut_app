import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
      email: email,
      password: password,
      name: name,
      phone: phone,
      imageUrl: imageUrl,
    );

    result.fold((failure) => emit(SignupFailure(message: failure.message)), (
      userEntity,
    ) async {
      // 🔥 الأمان: تم حذف سطر isLoggedIn وحذف تحديث ProfileCubit
      // لكي نجبر المستخدم على الذهاب لصفحة الـ Login وإدخال بياناته يدوياً
      log(
        "SignupCubit: User ${userEntity.email} registered. Waiting for login.",
      );
      emit(SignupSuccess(userEntity: userEntity));
    });
  }
}
