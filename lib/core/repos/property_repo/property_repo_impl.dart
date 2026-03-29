import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../../errors/failures.dart';
import '../../services/data_service.dart';
import '../../utils/backend_endpoint.dart';
import 'property_repo.dart';

class PropertyRepoImpl extends PropertyRepo {
  final DatabaseService databaseService;
  PropertyRepoImpl(this.databaseService);

  @override
  Stream<Either<Failure, List<PropertyEntity>>> getProperty() {
    return databaseService.streamData(path: BackendEndpoint.getProperty).map((
      data,
    ) {
      try {
        final properties = data
            .map((e) => PropertyModel.fromJson(e).toEntity())
            .toList();
        return right<Failure, List<PropertyEntity>>(properties);
      } catch (e) {
        return left<Failure, List<PropertyEntity>>(
          ServerFailure('فشل في معالجة البيانات'),
        );
      }
    });
  }

  @override
  Stream<Either<Failure, List<PropertyEntity>>> getMyProperties(
    String sellerId,
  ) {
    log("ProductsRepo: Fetching real-time properties for sellerId: $sellerId");
    return databaseService
        .streamData(
          path: BackendEndpoint.getProperty,
          whereField: 'sellerId',
          isEqualTo: sellerId,
        )
        .map((data) {
          try {
            final properties = data
                .map((e) => PropertyModel.fromJson(e).toEntity())
                .toList();
            return right<Failure, List<PropertyEntity>>(properties);
          } catch (e) {
            return left<Failure, List<PropertyEntity>>(
              ServerFailure('فشل في جلب عقاراتك الخاصة'),
            );
          }
        });
  }

  @override
  Future<Either<Failure, Unit>> deleteProperty(String productId) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoint.getProperty,
        documentId: productId,
      );
      return right(unit);
    } catch (e) {
      return left(ServerFailure("فشل حذف العقار: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePropertyStatus(
    String propertyId,
    Map<String, dynamic> data,
  ) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.getProperty,
        data: data,
        documentId: propertyId,
      );
      return right(unit);
    } catch (e) {
      return left(ServerFailure("فشل تحديث حالة العقار: ${e.toString()}"));
    }
  }
}
