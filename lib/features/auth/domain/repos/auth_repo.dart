import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entites/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String name,
    String phoneNumber,
    String? imageUrl,
    Timestamp Function() createdAt,
  );

  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  );

  Future addUserData({required UserEntity user});
  Future saveUserData({required UserEntity user});
  Future<UserEntity> getUserData({required String uid});
}
