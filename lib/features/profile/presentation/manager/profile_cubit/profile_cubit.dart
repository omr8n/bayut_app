import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/helper/functions/get_user.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import '../../../../auth/domain/entites/user_entity.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuthService _authService;
  UserEntity? user; 
  bool _isDarkMode = false; // 🔥 إضافة المتغير المفقود

  ProfileCubit(this._authService) : super(ProfileInitial()) {
    // تحميل حالة الثيم عند البداية
    _isDarkMode = Prefs.getBool('isDarkMode');
  }

  bool get isDarkMode => _isDarkMode;

  // 🔥 إعادة دالة تبديل الوضع الليلي
  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    Prefs.setBool('isDarkMode', value);
    emit(ProfileDarkModeToggled(value));
  }

  void updateUser(UserEntity newUser) {
    user = newUser;
    emit(ProfileUserLoaded(newUser));
  }

  Future<void> getUserInfo() async {
    if (!SecureStorage.isLoggedIn) return;
    try {
      emit(ProfileLoading()); // 🔥 تفعيل حالة التحميل للهيدر
      user = await getUser();
      if (user != null) {
        emit(ProfileUserLoaded(user!));
      } else {
        emit(ProfileInitial());
      }
    } catch (e) {
      user = null;
      emit(ProfileInitial());
    }
  }

  Future<void> logout() async {
    emit(ProfileLogoutLoading());
    try {
      await _authService.signOut();
      await SecureStorage.clearAll();
      user = null;
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileLogoutFailure('فشل في تسجيل الخروج'));
    }
  }
}
