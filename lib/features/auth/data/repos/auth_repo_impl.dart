import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/errors/exceptions.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/data_service.dart';
import '../../../../../core/services/firebase_auth_service.dart';
import '../../../../../core/utils/backend_endpoint.dart';
import '../../domain/entites/user_entity.dart';
import '../../domain/repos/auth_repo.dart';
import '../models/user_model.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });

  @override
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String name,
    String phoneNumber,
    String? imageUrl,
    Timestamp Function() createdAt,
  ) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userEntity = UserEntity(
        name: name,
        email: email,
        uId: user.uid,
        profilePic: imageUrl,
        phoneNumber: phoneNumber,
        createdAt: createdAt(),
      );

      await addUserData(user: userEntity);

      return right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(e.message));
    } catch (e) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signUp: ${e.toString()}');
      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    User user;
    try {
      user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserEntity userEntity = await getUserData(uid: user.uid);
      await saveUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signinWithEmailAndPassword: ${e.toString()}',
      );
      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  @override
  Future addUserData({required UserEntity user}) async {
    await databaseService.addData(
      path: BackendEndpoint.addUserData,
      data: UserModel.fromEntity(user).toMap(forFirestore: true),
      documentId: user.uId,
    );
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    var userData = await databaseService.getData(
      path: BackendEndpoint.getUsersData,
      documentId: uid,
    );
    return UserModel.fromJson(userData);
  }

  @override
  Future saveUserData({required UserEntity user}) async {
    String jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await SecureStorage.setString(AppConstants.kUserData, jsonData);
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }
}
