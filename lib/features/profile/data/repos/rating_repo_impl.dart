import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/features/profile/data/models/rating_model.dart';
import 'package:test_graduation/features/profile/domain/entities/rating_entity.dart';
import 'package:test_graduation/features/profile/domain/repos/rating_repo.dart';

class RatingRepoImpl implements RatingRepo {
  final DatabaseService databaseService;
  static const String ratingCollection = 'ratings';

  RatingRepoImpl(this.databaseService);

  @override
  Future<Either<Failure, void>> addRating(RatingEntity rating) async {
    try {
      final model = RatingModel.fromEntity(rating);
      await databaseService.addData(
        path: ratingCollection,
        data: model.toJson(),
        documentId: model.id,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('فشل إضافة التقييم: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, List<RatingEntity>>> getSellerRatings(String sellerId) {
    return databaseService
        .streamData(
          path: ratingCollection,
          whereField: 'sellerId',
          isEqualTo: sellerId,
        )
        .map((data) {
      try {
        final ratings = data.map((e) => RatingModel.fromJson(e)).toList();
        return Right<Failure, List<RatingEntity>>(ratings);
      } catch (e) {
        return Left<Failure, List<RatingEntity>>(
          ServerFailure('فشل جلب التقييمات'),
        );
      }
    });
  }
}
