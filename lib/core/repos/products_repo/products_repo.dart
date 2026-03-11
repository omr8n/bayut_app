import 'package:dartz/dartz.dart';

import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import '../../errors/failures.dart';

abstract class ProductsRepo {
  Stream<Either<Failure, List<PropertyEntity>>> getProducts();
  Future<Either<Failure, Unit>> deleteProduct(String productId);
  // Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts();
}
