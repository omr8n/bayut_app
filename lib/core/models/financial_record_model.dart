import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { promotionWeekly, promotionMonthly, extraPropertyListing }

class FinancialRecordModel {
  final String id;
  final String propertyId;
  final String sellerId;
  final String sellerName;
  final double amount;
  final String currency;
  final TransactionType type;
  final DateTime createdAt;

  FinancialRecordModel({
    required this.id,
    required this.propertyId,
    required this.sellerId,
    required this.sellerName,
    required this.amount,
    required this.currency,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'amount': amount,
      'currency': currency,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FinancialRecordModel.fromJson(Map<String, dynamic> json) {
    return FinancialRecordModel(
      id: json['id'] as String? ?? '',
      propertyId: json['propertyId'] as String? ?? '',
      sellerId: json['sellerId'] as String? ?? '',
      sellerName: json['sellerName'] as String? ?? '',
      amount: (json['amount'] as num? ?? 0).toDouble(),
      currency: json['currency'] as String? ?? 'ل.س',
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.promotionWeekly,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
