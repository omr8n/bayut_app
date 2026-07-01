import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import '../../manager/profile_cubit/profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = context.read<ProfileCubit>().user;

        String name = user?.name ?? locale!.translate(LangKeys.guestUser);
        String email = user?.email ?? locale!.translate(LangKeys.loginToPost);
        String? imageUrl = user?.profilePic;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 60,
            bottom: 30,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
            borderRadius: const BorderRadius.only(
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
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 15),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
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
