import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String email;
  final String uId;
  final String? profilePic;
  final String? phoneNumber;
  final Timestamp? createdAt;
  final List<String>? userCart;
  final List<String>? userWish;
  final String role; // 'user', 'admin', 'agent'
  final String status; // 'active', 'frozen', 'banned'
  final String? adminNotes;
  final bool isVerified;
  final int propertiesCount;
  final int reportsCount;
  final int dailyListingsCount; // 🔥 عدد العقارات المنشورة اليوم
  final Timestamp? lastListingTimestamp; // 🔥 توقيت آخر عملية نشر
  final String? fcmToken; // 🔥 حقل التوكن للإشعارات
  final dynamic lastDocSnapshot; // 🔥 لتخزين الـ Cursor الخاص بالـ Pagination (تجاهل في Equatable)

  const UserEntity({
    required this.name,
    required this.email,
    required this.uId,
    this.role = 'user',
    this.status = 'active',
    this.profilePic,
    this.phoneNumber,
    this.createdAt,
    this.userCart = const [],
    this.userWish = const [],
    this.adminNotes,
    this.isVerified = false,
    this.propertiesCount = 0,
    this.reportsCount = 0,
    this.dailyListingsCount = 0,
    this.lastListingTimestamp,
    this.fcmToken,
    this.lastDocSnapshot,
  });

  // Getters ذكية
  bool get isAdmin => role == 'admin';
  bool get isAgent => role == 'agent';
  bool get isBanned => status == 'banned';
  bool get isFrozen => status == 'frozen';
  bool get isActive => status == 'active';

  UserEntity copyWith({
    String? name,
    String? email,
    String? uId,
    String? profilePic,
    String? phoneNumber,
    Timestamp? createdAt,
    List<String>? userCart,
    List<String>? userWish,
    String? role,
    String? status,
    String? adminNotes,
    bool? isVerified,
    int? propertiesCount,
    int? reportsCount,
    int? dailyListingsCount,
    Timestamp? lastListingTimestamp,
    String? fcmToken,
    dynamic lastDocSnapshot,
  }) {
    return UserEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      uId: uId ?? this.uId,
      profilePic: profilePic ?? this.profilePic,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      userCart: userCart ?? this.userCart,
      userWish: userWish ?? this.userWish,
      role: role ?? this.role,
      status: status ?? this.status,
      adminNotes: adminNotes ?? this.adminNotes,
      isVerified: isVerified ?? this.isVerified,
      propertiesCount: propertiesCount ?? this.propertiesCount,
      reportsCount: reportsCount ?? this.reportsCount,
      dailyListingsCount: dailyListingsCount ?? this.dailyListingsCount,
      lastListingTimestamp: lastListingTimestamp ?? this.lastListingTimestamp,
      fcmToken: fcmToken ?? this.fcmToken,
      lastDocSnapshot: lastDocSnapshot ?? this.lastDocSnapshot,
    );
  }

  @override
  List<Object?> get props => [
        uId,
        email,
        name,
        role,
        status,
        profilePic,
        phoneNumber,
        isVerified,
        userWish,
        userCart,
        fcmToken,
      ];
}
