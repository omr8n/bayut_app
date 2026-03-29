import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String name;
  final String email;
  final String uId;
  final String? profilePic; // تفعيل حقل الصورة
  final String? phoneNumber; // إضافة رقم الهاتف
  final Timestamp? createdAt;
  final List? userCart, userWish;

  UserEntity({
    required this.name,
    required this.email,
    required this.uId,
    this.profilePic,
    this.phoneNumber,
    this.createdAt,
    this.userCart,
    this.userWish,
  });
}
