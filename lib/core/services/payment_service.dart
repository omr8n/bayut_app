import 'package:uuid/uuid.dart';
import 'package:test_graduation/core/models/financial_record_model.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class PaymentService {
  /// محاكاة عملية دفع لنشر عقار إضافي
  Future<bool> processExtraListingPayment({
    required UserEntity user,
    required double amount,
    required String propertyTitle,
    required String paymentMethod,
    required String currency, // 🔥 إضافة العملة
  }) async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 2));

      final transactionId = const Uuid().v4();
      final record = FinancialRecordModel(
        id: transactionId,
        propertyId: "extra_listing_${DateTime.now().millisecondsSinceEpoch}",
        propertyTitle: propertyTitle,
        sellerId: user.uId,
        sellerName: user.name,
        amount: amount,
        currency: currency, // 🔥 استخدام العملة الديناميكية
        type: TransactionType.extraPropertyListing,
        createdAt: DateTime.now(),
      );

      // حفظ السجل المالي في Firestore ليرسمه الأدمن
      await getIt<DatabaseService>().addData(
        path: BackendEndpoint.financialTransfers,
        data: record.toJson(),
        documentId: transactionId,
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
