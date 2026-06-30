import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/card_action_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyManageCard extends StatelessWidget {
  final PropertyEntity property;

  const PropertyManageCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    property.media.isNotEmpty ? property.media.first : '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${numberFormat.format(property.price)} ${property.currency}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14.sp,
                            color: Colors.grey,
                          ),
                          Text(
                            property.city,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // خانة المشاهدات (Views Count)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 14.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate(LangKeys.viewsCount)
                                  .replaceAll(
                                    '{count}',
                                    property.views.toString(),
                                  ),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardActionWidget(
                  icon: Icons.edit_outlined,
                  label: AppLocalizations.of(context)!.translate(LangKeys.edit),
                  color: Colors.blue,
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).push(AppRoutes.addPropertyScreen, extra: property);
                  },
                ),
                CardActionWidget(
                  icon: Icons.delete_outline,
                  label: AppLocalizations.of(
                    context,
                  )!.translate(LangKeys.delete),
                  color: Colors.red,
                  onTap: () {
                    if (user != null) {
                      context.read<MyPropertiesCubit>().deleteProperty(
                        property.id,
                        user.uid,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
