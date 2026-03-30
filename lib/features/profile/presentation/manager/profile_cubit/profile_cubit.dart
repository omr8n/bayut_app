import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/helper/functions/get_user.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import '../../../../auth/domain/entites/user_entity.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuthService _authService;
  UserEntity? user; // 🔥 مخزن بيانات المستخدم

  ProfileCubit(this._authService) : super(ProfileInitial());

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // 🔥 جلب بيانات المستخدم وتحديث الحالة
  Future<void> getUserInfo() async {
    if (!SecureStorage.isLoggedIn) return;
    try {
      user = await getUser();
      emit(ProfileUserLoaded(user!));
    } catch (e) {
      // معالجة الخطأ بصمت
    }
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    emit(ProfileDarkModeToggled(value));
  }

  Future<void> logout() async {
    emit(ProfileLogoutLoading());
    try {
      await _authService.signOut();
      await SecureStorage.clearAll();
      user = null;
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileLogoutFailure('فشل في تسجيل الخروج: ${e.toString()}'));
    }
  }
}
