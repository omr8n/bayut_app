import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

abstract class FavoritesRepo {
  Future<Either<Failure, void>> toggleFavorite({
    required String userId,
    required String propertyId,
  });
  Stream<Either<Failure, List<PropertyEntity>>> getFavoriteProperties(String userId);
}
