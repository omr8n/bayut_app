import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? imageUrl,
  });

  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? imageUrl,
  });

  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, void>> updatePassword({required String newPassword});
  Future<Either<Failure, void>> reauthenticate({required String email, required String password});
  Future<Either<Failure, void>> updateUserData({required UserEntity user});

  Future addUserData({required UserEntity user});
  Future saveUserData({required UserEntity user});
  Future<UserEntity> getUserData({required String uid});
}
