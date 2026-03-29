import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.uId,
    super.profilePic,
    super.phoneNumber,
    super.createdAt,
    super.userCart,
    super.userWish,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      uId: user.uid,
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
      profilePic: json['profilePic'],
      phoneNumber: json['phoneNumber'],
      // 🔥 التعامل الذكي مع التاريخ: إذا كان نصاً (من SecureStorage) أو Timestamp (من Firestore)
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
      profilePic: user.profilePic,
      phoneNumber: user.phoneNumber,
      createdAt: user.createdAt,
      userCart: user.userCart,
      userWish: user.userWish,
    );
  }

  @override
  Map<String, dynamic> toMap({bool forFirestore = false}) {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      // 🔥 التحويل الموحد: للـ Firestore نرسل ServerTimestamp، وللـ Local نرسل String
      'createdAt': forFirestore 
          ? (createdAt ?? FieldValue.serverTimestamp()) 
          : createdAt?.toDate().toIso8601String(),
      'userCart': userCart ?? [],
      'userWish': userWish ?? [],
    };
  }
}
