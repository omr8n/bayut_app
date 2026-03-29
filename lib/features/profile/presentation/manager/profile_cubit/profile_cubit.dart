import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuthService _authService;

  ProfileCubit(this._authService) : super(ProfileInitial());

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    emit(ProfileDarkModeToggled(value));
  }

  Future<void> logout() async {
    emit(ProfileLogoutLoading());
    try {
      // 🔥 التصحيح: استخدام signOut بدلاً من deleteUser لتجنب خطأ الحماية
      await _authService.signOut();
      
      // مسح كافة البيانات المحلية
      await SecureStorage.clearAll();
      
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileLogoutFailure('فشل في تسجيل الخروج: ${e.toString()}'));
    }
  }
}
