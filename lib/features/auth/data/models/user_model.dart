import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.uId,
    required super.role,
    super.status = 'active',
    super.profilePic,
    super.phoneNumber,
    super.createdAt,
    super.userCart,
    super.userWish,
    super.adminNotes,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      uId: user.uid,
      role: 'user',
      status: 'active',
      profilePic: user.photoURL,
      phoneNumber: user.phoneNumber,
      createdAt: Timestamp.now(),
      userCart: [],
      userWish: [],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      uId: json['uId'] ?? '',
      role: json['role'] ?? 'user',
      status: json['status'] ?? 'active',
      profilePic: json['profilePic'],
      phoneNumber: json['phoneNumber'],
      adminNotes: json['adminNotes'],
      createdAt: json['createdAt'] == null
          ? null
          : (json['createdAt'] is String
              ? Timestamp.fromDate(DateTime.parse(json['createdAt']))
              : json['createdAt'] as Timestamp),
      userCart: List.from(json['userCart'] ?? []),
      userWish: List.from(json['userWish'] ?? []),
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      name: user.name,
      email: user.email,
      uId: user.uId,
      role: user.role,
      status: user.status,
      profilePic: user.profilePic,
      phoneNumber: user.phoneNumber,
      createdAt: user.createdAt,
      userCart: user.userCart,
      userWish: user.userWish,
      adminNotes: user.adminNotes,
    );
  }

  Map<String, dynamic> toMap({bool forFirestore = false}) {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'role': role,
      'status': status,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'adminNotes': adminNotes,
      'createdAt': forFirestore
          ? (createdAt ?? FieldValue.serverTimestamp())
          : createdAt?.toDate().toIso8601String(),
      'userCart': userCart ?? [],
      'userWish': userWish ?? [],
    };
  }
}
