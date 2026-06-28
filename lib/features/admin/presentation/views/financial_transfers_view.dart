import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/models/financial_record_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinancialTransfersView extends StatelessWidget {
  const FinancialTransfersView({super.key});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.financial_wallet_title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getIt<DatabaseService>().streamData(
          path: BackendEndpoint.financialTransfers,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(local.no_financial_transfers));
          }

          final records =
              snapshot.data!
                  .map((e) => FinancialRecordModel.fromJson(e))
                  .toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final totalAmount = records.fold<double>(
            0,
            (sum, item) => sum + item.amount,
          );

          return Column(
            children: [
              // Summary Card
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      local.total_premium_revenue,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${numberFormat.format(totalAmount)} ${local.currency_lira}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    String typeText;
                    switch (record.type) {
                      case TransactionType.promotionMonthly:
                        typeText = local.monthly_package;
                        break;
                      case TransactionType.promotionWeekly:
                        typeText = local.weekly_package;
                        break;
                      case TransactionType.extraPropertyListing:
                        typeText = local.translate(LangKeys.extraListingFee);
                        break;
                    }

                    return _buildTransferItem(
                      record,
                      typeText,
                      numberFormat,
                      local,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTransferItem(
    FinancialRecordModel record,
    String typeText,
    NumberFormat format,
    AppLocalizations local,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: record.type == TransactionType.extraPropertyListing
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              record.type == TransactionType.extraPropertyListing
                  ? Icons.rocket_launch_rounded
                  : Icons.account_balance_wallet_rounded,
              color: record.type == TransactionType.extraPropertyListing
                  ? Colors.blue
                  : Colors.green,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.sellerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  typeText,
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${format.format(record.amount)}',
                style: TextStyle(
                  color: record.type == TransactionType.extraPropertyListing
                      ? Colors.blue
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                DateFormat('yyyy/MM/dd').format(record.createdAt),
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
