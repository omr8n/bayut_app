import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/helper/functions/get_user.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/features/auth/data/models/user_model.dart';
import '../../../../auth/domain/entites/user_entity.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuthService _authService;
  final DatabaseService _databaseService;
  UserEntity? user;
  bool _isDarkMode = false;
  StreamSubscription? _userSubscription;

  ProfileCubit(this._authService, this._databaseService) : super(ProfileInitial()) {
    _isDarkMode = Prefs.getBool('isDarkMode');
  }

  bool get isDarkMode => _isDarkMode;

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

    if (user != null) {
      emit(ProfileUserLoaded(user!));
    }

    try {
      final uId = await SecureStorage.getString('uId');
      if (uId.isEmpty) return;

      _userSubscription?.cancel();
      _userSubscription = _databaseService.streamData(
        path: BackendEndpoint.getUsersData,
      ).listen((usersList) {
        try {
          final userData = usersList.firstWhere(
            (data) => data['uId'] == uId,
          );
          user = UserModel.fromJson(userData);
          emit(ProfileUserLoaded(user!));
        } catch (e) {
          // User not found in stream
        }
      });

      var cachedUser = await getUser();
      if (cachedUser != null && user == null) {
        user = cachedUser;
        emit(ProfileUserLoaded(user!));
      }
    } catch (e) {
      if (user == null) emit(ProfileInitial());
    }
  }

  Future<void> logout() async {
    emit(ProfileLogoutLoading());
    try {
      _userSubscription?.cancel();
      await _authService.signOut();
      await SecureStorage.clearAll();
      user = null;
      emit(ProfileInitial());
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileLogoutFailure('فشل في تسجيل الخروج'));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return Future.value();
  }
}
