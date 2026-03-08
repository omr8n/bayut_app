import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/property_model.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repos/add_property_repo.dart';

class AddPropertyRepoImpl implements AddPropertyRepo {
  // final FirebaseFirestore firestore;

  const AddPropertyRepoImpl(this.databaseService);
  // AddPropertiesRepoImpl(this.firestore);
  final DatabaseService databaseService;
  @override
  Future<Either<Failure, String>> addProperty(PropertyEntity property) async {
    try {
      // تحويل الـ Entity إلى Model لاستخدام toJson
      final String newId = const Uuid().v4();
      debugPrint("✅ newId: $newId");

      final updatedProduct = property.copyWith(id: newId);
      debugPrint("✅ updatedProduct: $updatedProduct");

      final productModel = PropertyModel.fromEntity(updatedProduct);
      debugPrint("✅ productModel json: ${productModel.toJson()}");

      final documentId = await databaseService.addData(
        path: BackendEndpoint.propertyCollection,
        data: productModel.toJson(),
        documentId: newId,
      );
      debugPrint("✅ documentId: $documentId");

      return Right(documentId);
    } catch (e, stack) {
      debugPrint("🔥 Error in addProperty: $e");
      debugPrint("📌 Stacktrace: $stack");
      return Left(ServerFailure('فشل حفظ بيانات العقار: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> editProperty(PropertyEntity property) async {
    try {
      final propertyModel = PropertyModel.fromEntity(property);

      await databaseService.updateData(
        path: BackendEndpoint.propertyCollection,
        data: propertyModel.toJson(),
        documentId: property.id,
      );

      return const Right(null);
    } catch (e, stack) {
      debugPrint("🔥 Error in editProperty: $e");
      debugPrint("📌 Stacktrace: $stack");
      return Left(ServerFailure('فشل تعديل بيانات العقار: $e'));
    }
  }
}
