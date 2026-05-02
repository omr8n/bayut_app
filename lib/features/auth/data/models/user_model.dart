import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.email,
    required super.uId,
    super.role = 'user',
    super.status = 'active',
    super.profilePic,
    super.phoneNumber,
    super.createdAt,
    super.userCart = const [],
    super.userWish = const [],
    super.adminNotes,
    super.isVerified = false,
    super.propertiesCount = 0,
    super.reportsCount = 0,
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
      userCart: const [],
      userWish: const [],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      uId: json['uId'] ?? json['id'] ?? '',
      role: json['role'] ?? json['userType'] ?? 'user',
      status: json['status'] ?? 'active',
      profilePic: json['profilePic'] ?? json['photoUrl'],
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      adminNotes: json['adminNotes'],
      isVerified: json['isVerified'] ?? false,
      propertiesCount: json['propertiesCount'] ?? 0,
      reportsCount: json['reportsCount'] ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : (json['createdAt'] is String
                ? Timestamp.fromDate(DateTime.parse(json['createdAt']))
                : json['createdAt'] as Timestamp),
      userCart: List<String>.from(json['userCart'] ?? []),
      userWish: List<String>.from(
        json['userWish'] ?? json['favoriteProperties'] ?? [],
      ),
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
      isVerified: user.isVerified,
      propertiesCount: user.propertiesCount,
      reportsCount: user.reportsCount,
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
      'isVerified': isVerified,
      'propertiesCount': propertiesCount,
      'reportsCount': reportsCount,
      'createdAt': forFirestore
          ? (createdAt ?? FieldValue.serverTimestamp())
          : createdAt?.toDate().toIso8601String(),
      'userCart': userCart ?? [],
      'userWish': userWish ?? [],
    };
  }
}
