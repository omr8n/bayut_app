import 'dart:convert';

import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/entites/user_entity.dart';

Future<UserEntity> getUser() async {
  var jsonString = await SecureStorage.getString(AppConstants.kUserData);
  UserEntity userEntity = UserModel.fromJson(jsonDecode(jsonString));
  return userEntity;
}
