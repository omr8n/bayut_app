import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/cubits/app_cubit/app_cubit.dart';
import 'package:test_graduation/core/helper/functions/get_user.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';

import 'package:test_graduation/core/services/fcm_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/features/auth/data/models/user_model.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import '../../../../auth/domain/entites/user_entity.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuthService _authService;
  final DatabaseService _databaseService;
  UserEntity? user;
  bool _isDarkMode = false;
  StreamSubscription? _userSubscription;

  ProfileCubit(this._authService, this._databaseService)
    : super(ProfileInitial());

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode(BuildContext context, bool value) {
    _isDarkMode = value;
    context.read<AppCubit>().changeAppThemeMode(sharedMode: value);
    emit(ProfileDarkModeToggled(value));
  }

  void updateUser(UserEntity newUser) {
    user = newUser;
    saveFcmToken(); // 🔥 حفظ التوكن عند تحديث بيانات المستخدم
    FCMService()
        .subscribeToAllTopic(); // 🔥 الاشتراك في الإشعارات العامة عند تسجيل الدخول
    emit(ProfileUserLoaded(newUser));
  }

  Future<void> saveFcmToken() async {
    if (user == null) return;
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null && token != user!.fcmToken) {
        await _databaseService.updateData(
          path: BackendEndpoint.updateUserData,
          documentId: user!.uId,
          data: {'fcmToken': token},
        );
      }
    } catch (e) {
      // فشل حفظ التوكن ليس حرجاً
    }
  }

  Future<void> getUserInfo() async {
    // 🔥 فحص صارم للجلسة قبل البدء
    if (!SecureStorage.isLoggedIn) {
      log("ℹ️ ProfileCubit: User is NOT logged in. Skipping Firestore stream.");
      user = null;
      _userSubscription?.cancel();
      FCMService().unsubscribeFromAllTopic(); 
      emit(ProfileInitial());
      return;
    }

    if (user != null) {
      FCMService().subscribeToAllTopic(); 
      emit(ProfileUserLoaded(user!));
    }

    try {
      final uId = await SecureStorage.getString('uId');
      if (uId.isEmpty) {
        log("⚠️ ProfileCubit: isLoggedIn is true but uId is empty. Resetting session.");
        await logout();
        return;
      }

      _userSubscription?.cancel();
      _userSubscription = _databaseService
          .streamDocument(path: BackendEndpoint.getUsersData, documentId: uId)
          .listen((userData) {
            try {
              if (userData == null) return;
              
              // فحص الحالة قبل تحديث الكائن المحلي
              final String status = userData['status'] ?? 'active';
              
              if (status == 'banned') {
                log("🚫 ProfileCubit: User $uId is BANNED.");
                _userSubscription?.cancel();
                if (SecureStorage.isLoggedIn) {
                  // تحديث التوكن في الخلفية لمنع الرسائل
                  _databaseService.updateData(
                    path: BackendEndpoint.updateUserData,
                    documentId: uId,
                    data: {'fcmToken': ''},
                  ).catchError((e) => log("⚠️ Error clearing token on ban: $e"));

                  SecureStorage.setBool('isLoggedIn', false); 
                  FCMService().unsubscribeFromAllTopic();
                  emit(ProfileUserBanned());
                }
              } else if (status == 'deleted') {
                log("🗑️ ProfileCubit: User $uId is DELETED.");
                _userSubscription?.cancel();
                if (SecureStorage.isLoggedIn) {
                  _databaseService.updateData(
                    path: BackendEndpoint.updateUserData,
                    documentId: uId,
                    data: {'fcmToken': ''},
                  ).catchError((e) => log("⚠️ Error clearing token on delete: $e"));

                  SecureStorage.setBool('isLoggedIn', false);
                  FCMService().unsubscribeFromAllTopic();
                  emit(ProfileUserDeleted());
                }
              } else {
                user = UserModel.fromJson(userData);
                saveFcmToken(); 
                FCMService().subscribeToAllTopic(); 
                emit(ProfileUserLoaded(user!));
              }
            } catch (e) {
              log("❌ ProfileCubit: Stream parsing error: $e");
            }
          });

      var cachedUser = await getUser();
      if (cachedUser != null && user == null) {
        user = cachedUser;
        emit(ProfileUserLoaded(user!));
      }
    } catch (e) {
      log("❌ ProfileCubit: Fatal error in getUserInfo: $e");
      if (user == null) emit(ProfileInitial());
    }
  }

  Future<void> logout() async {
    emit(ProfileLogoutLoading());
    try {
      _userSubscription?.cancel();
      _userSubscription = null;

      // 🔥 تنظيف التوكن من السيرفر لضمان العزل
      if (user != null) {
        try {
          await _databaseService.updateData(
            path: BackendEndpoint.updateUserData,
            documentId: user!.uId,
            data: {'fcmToken': ''},
          );
        } catch (e) {
          log("⚠️ ProfileCubit: Failed to clear FCM token during logout: $e");
        }
      }

      await FCMService().unsubscribeFromAllTopic(); 
      await _authService.signOut();
      await SecureStorage.clearAll();

      // 🔥 إعادة تعيين حالات الـ Cubits المرتبطة بالمستخدم بشكل آمن
      if (getIt.isRegistered<MyPropertiesCubit>()) {
        getIt.get<MyPropertiesCubit>().resetState();
      }
      if (getIt.isRegistered<FavoritesCubit>()) {
        getIt.get<FavoritesCubit>().resetState();
      }

      user = null;
      emit(ProfileInitial());
      emit(ProfileLogoutSuccess());
    } catch (e) {
      log("❌ ProfileCubit: Logout error: $e");
      // نضمن تصفير الحالة حتى لو فشل الاتصال بالشبكة
      user = null;
      _userSubscription?.cancel();
      await SecureStorage.clearAll();
      emit(ProfileInitial());
      emit(ProfileLogoutSuccess());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
