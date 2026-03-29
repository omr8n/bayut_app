import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/rating_entity.dart';

abstract class RatingRepo {
  Future<Either<Failure, void>> addRating(RatingEntity rating);
  Stream<Either<Failure, List<RatingEntity>>> getSellerRatings(String sellerId);
}
