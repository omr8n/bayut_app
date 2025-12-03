import 'package:equatable/equatable.dart';

// نموذج المستخدم
class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? photoUrl;
  final UserType userType; // مستخدم عادي أو معلن
  final DateTime createdAt;
  final List<String> favoriteProperties; // العقارات المفضلة

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.userType,
    required this.createdAt,
    this.favoriteProperties = const [],
  });

  // من JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photoUrl: json['photoUrl'] as String?,
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['userType']}',
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      favoriteProperties: List<String>.from(
        json['favoriteProperties'] as List? ?? [],
      ),
    );
  }

  // إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'userType': userType.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'favoriteProperties': favoriteProperties,
    };
  }

  // نسخ مع تعديلات
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? photoUrl,
    UserType? userType,
    DateTime? createdAt,
    List<String>? favoriteProperties,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      favoriteProperties: favoriteProperties ?? this.favoriteProperties,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    photoUrl,
    userType,
    createdAt,
    favoriteProperties,
  ];
}

// نوع المستخدم
enum UserType {
  user, // مستخدم عادي
  agent, // معلن
}

extension UserTypeExtension on UserType {
  String get arabicName {
    switch (this) {
      case UserType.user:
        return 'مستخدم';
      case UserType.agent:
        return 'معلن';
    }
  }
}
