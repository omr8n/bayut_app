import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';

class ListingLimitService {
  /// للتحقق مما إذا كان بإمكان المستخدم النشر مجاناً
  Future<Map<String, dynamic>> checkListingLimit(UserEntity user) async {
    final now = DateTime.now();

    // جلب الإعدادات الحالية من الـ Cubit
    final context = RouterGenerationConfig.goRouter.configuration.navigatorKey.currentContext!;
    final config = context.read<AdminSettingsCubit>().currentConfig;
    final int dailyFreeLimit = config?.freePropertyLimitPerDay ?? 3;

    // إذا لم ينشر أبداً من قبل، فهو مسموح له
    if (user.lastListingTimestamp == null) {
      return {'canListFree': true, 'remaining': dailyFreeLimit};
    }

    final lastListing = user.lastListingTimestamp!.toDate();
    final difference = now.difference(lastListing);

    // إذا مر أكثر من 24 ساعة، يتم تصفير العداد
    if (difference.inHours >= 24) {
      return {'canListFree': true, 'remaining': dailyFreeLimit};
    }

    // إذا لم تمر 24 ساعة، نتحقق من عدد العقارات المنشورة
    if (user.dailyListingsCount < dailyFreeLimit) {
      return {
        'canListFree': true,
        'remaining': dailyFreeLimit - user.dailyListingsCount
      };
    }

    // وصل للحد ولم تمر 24 ساعة
    final remainingTime = const Duration(hours: 24) - difference;
    return {
      'canListFree': false,
      'remaining': 0,
      'nextFreeTime': remainingTime,
    };
  }

  /// تحديث عداد النشر للمستخدم
  Future<void> incrementListingCount(String userId) async {
    final db = getIt<DatabaseService>();
    final userData = await db.getData(
      path: BackendEndpoint.getUsersData,
      documentId: userId,
    );

    if (userData != null) {
      int currentCount = userData['dailyListingsCount'] ?? 0;
      final lastListingTimestamp = userData['lastListingTimestamp'] as Timestamp?;
      final now = DateTime.now();

      if (lastListingTimestamp != null) {
        final lastDate = lastListingTimestamp.toDate();
        if (now.difference(lastDate).inHours >= 24) {
          currentCount = 0; // تصفير إذا مر يوم
        }
      }

      await db.updateData(
        path: BackendEndpoint.updateUserData,
        documentId: userId,
        data: {
          'dailyListingsCount': currentCount + 1,
          'lastListingTimestamp': Timestamp.fromDate(now),
        },
      );
    }
  }
}
