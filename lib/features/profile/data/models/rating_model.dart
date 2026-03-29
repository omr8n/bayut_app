import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  const RatingModel({
    required super.id,
    required super.sellerId,
    required super.raterId,
    required super.raterName,
    super.raterImage,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as String? ?? '',
      sellerId: json['sellerId'] as String? ?? '',
      raterId: json['raterId'] as String? ?? '',
      raterName: json['raterName'] as String? ?? 'مستخدم',
      raterImage: json['raterImage'] as String?,
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp 
              ? (json['createdAt'] as Timestamp).toDate() 
              : DateTime.parse(json['createdAt'] as String))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'raterId': raterId,
      'raterName': raterName,
      'raterImage': raterImage,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RatingModel.fromEntity(RatingEntity entity) {
    return RatingModel(
      id: entity.id,
      sellerId: entity.sellerId,
      raterId: entity.raterId,
      raterName: entity.raterName,
      raterImage: entity.raterImage,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
    );
  }
}
