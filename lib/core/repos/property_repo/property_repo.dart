import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/services/connectivity_service.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../../errors/failures.dart';

abstract class PropertyRepo {
  ConnectivityService get connectivityService;
  Stream<Either<Failure, List<PropertyEntity>>> getProperty();

  Stream<Either<Failure, List<PropertyEntity>>> getMyProperties(
    String sellerId,
  );

  Future<Either<Failure, Unit>> deleteProperty(String productId);

  // 🔥 إضافة التعريف المفقود هنا
  Future<Either<Failure, Unit>> updatePropertyStatus(
    String propertyId,
    Map<String, dynamic> data,
  );
}
