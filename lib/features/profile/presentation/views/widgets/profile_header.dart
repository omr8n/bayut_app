import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/auth/data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 فحص حالة تسجيل الدخول
    final bool isLoggedIn = SecureStorage.isLoggedIn;

    return FutureBuilder<String>(
      future: SecureStorage.getString(AppConstants.kUserData),
      builder: (context, snapshot) {
        String name = "مستخدم زائر";
        String email = "سجل دخولك لتتمكن من إضافة عقارات";
        String? imageUrl;

        if (isLoggedIn && snapshot.hasData && snapshot.data!.isNotEmpty) {
          try {
            final user = UserModel.fromJson(jsonDecode(snapshot.data!));
            name = user.name;
            email = user.email;
            imageUrl = user.profilePic;
          } catch (_) {}
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? Text(
                        name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(height: 15),
              Text(
                name,
                style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }
}
