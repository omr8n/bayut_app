import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class ListingLimitService {
  static const int dailyFreeLimit = 3;

  /// للتحقق مما إذا كان بإمكان المستخدم النشر مجاناً
  Future<Map<String, dynamic>> checkListingLimit(UserEntity user) async {
    final now = DateTime.now();

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
