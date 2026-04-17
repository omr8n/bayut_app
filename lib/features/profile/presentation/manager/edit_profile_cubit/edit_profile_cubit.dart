import '../../../../../../core/language/app_localizations.dart';
import '../../../../../../core/language/lang_keys.dart';
import '../../../../../../core/routing/router_generation_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/repos/media_repo/media_repo.dart';
import '../../../../auth/domain/entites/user_entity.dart';
import '../../../../auth/domain/repos/auth_repo.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final AuthRepo authRepo;
  final MediaRepo mediaRepo;

  EditProfileCubit(this.authRepo, this.mediaRepo) : super(EditProfileInitial());

  Future<void> updateProfile({
    required UserEntity currentUser,
    required String name,
    required String phone,
    required String email,
    String? oldPassword,
    String? newPassword,
    XFile? imageFile,
  }) async {
    emit(EditProfileLoading());

    try {
      String? imageUrl = currentUser.profilePic;

      // 1. Upload Image if changed
      if (imageFile != null) {
        final uploadResult = await mediaRepo.uploadMedia(imageFile);
        uploadResult.fold((failure) {
          final context = RouterGenerationConfig
              .goRouter
              .configuration
              .navigatorKey
              .currentContext!;
          final locale = AppLocalizations.of(context)!;
          throw Exception(
            locale.translate(LangKeys.uploadImageFailed).replaceFirst(
              '{error}',
              failure.message,
            ),
          );
        }, (url) => imageUrl = url);
      }

      // 2. Update Password if provided
      if (newPassword != null && newPassword.isNotEmpty && oldPassword != null) {
        // Reauthenticate first
        final reauthResult = await authRepo.reauthenticate(
          email: currentUser.email,
          password: oldPassword,
        );
        
        bool reauthFailed = false;
        reauthResult.fold(
          (failure) {
            reauthFailed = true;
            emit(EditProfileFailure(failure.message));
          },
          (_) => null,
        );
        if (reauthFailed) return;

        // Update password
        final passwordResult = await authRepo.updatePassword(newPassword: newPassword);
        bool passwordFailed = false;
        passwordResult.fold(
          (failure) {
            passwordFailed = true;
            emit(EditProfileFailure(failure.message));
          },
          (_) => null,
        );
        if (passwordFailed) return;
      }

      // 3. Update User Data in Firestore
      final updatedUser = UserEntity(
        name: name,
        email: email, // Note: updating email in Firebase Auth is more complex, keeping it for Firestore here
        uId: currentUser.uId,
        phoneNumber: phone,
        profilePic: imageUrl,
        createdAt: currentUser.createdAt,
        userCart: currentUser.userCart,
        userWish: currentUser.userWish,
      );

      final result = await authRepo.updateUserData(user: updatedUser);

      result.fold(
        (failure) => emit(EditProfileFailure(failure.message)),
        (_) => emit(EditProfileSuccess(updatedUser)),
      );
    } catch (e) {
      emit(EditProfileFailure(e.toString()));
    }
  }
}
