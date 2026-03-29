import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  final String id;
  final String sellerId;
  final String raterId;
  final String raterName;
  final String? raterImage;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const RatingEntity({
    required this.id,
    required this.sellerId,
    required this.raterId,
    required this.raterName,
    this.raterImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, sellerId, raterId, rating, comment, createdAt];
}
