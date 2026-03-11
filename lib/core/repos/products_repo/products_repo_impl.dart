import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import '../../errors/failures.dart';

import '../../services/data_service.dart';
import '../../utils/backend_endpoint.dart';
import 'products_repo.dart';

// class ProductsRepoImpl extends ProductsRepo {
//   final DatabaseService databaseService;

//   ProductsRepoImpl(this.databaseService);
//   // @override
//   // Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts() async {
//   //   try {
//   //     List<Map<String, dynamic>> data =
//   //         await databaseService.getData(
//   //               path: BackendEndpoint.getProducts,
//   //               query: {
//   //                 'limit': 10,
//   //                 'orderBy': 'sellingCount',
//   //                 'descending': true,
//   //               },
//   //             )
//   //             as List<Map<String, dynamic>>;

//   //     List<ProductEntity> products =
//   //         data.map((e) => ProductModel.fromJson(e).toEntity()).toList();
//   //     return right(products);
//   //   } catch (e) {
//   //     return left(ServerFailure('Failed to get products'));
//   //   }
//   // }

//   @override
//   Stream<Either<Failure, List<ProductEntity>>> getProducts() async* {
//     try {
//       List<Map<String, dynamic>> data =
//           await databaseService.getData(path: BackendEndpoint.getProducts)
//               as List<Map<String, dynamic>>;

//       List<ProductEntity> products = data
//           .map((e) => ProductModel.fromJson(e).toEntity())
//           .toList();
//       //  List<ProductEntity> productsEntity = products.map((e) => e.toEntity()).toList();
//       yield right(products);
//     } catch (e, stackTrace) {
//       log('❌ Error while fetching products: $e');
//       log('🧱 StackTrace: $stackTrace');
//       yield left(ServerFailure('Failed to get products: ${e.toString()}'));
//     }
//   }
// }
class ProductsRepoImpl extends ProductsRepo {
  final DatabaseService databaseService;
  ProductsRepoImpl(this.databaseService);

  @override
  Stream<Either<Failure, List<PropertyEntity>>> getProducts() async* {
    try {
      List<Map<String, dynamic>> data =
          await databaseService.getData(path: BackendEndpoint.getProperty)
              as List<Map<String, dynamic>>;

      List<PropertyEntity> properties = data
          .map((e) => PropertyModel.fromJson(e).toEntity())
          .toList();

      yield right(properties);
    } catch (e, stackTrace) {
      log('❌ Error while fetching products: $e');
      log('🧱 StackTrace: $stackTrace');
      yield left(ServerFailure('Failed to get products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String productId) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoint.getProperty,
        documentId: productId,
      );
      return right(unit);
    } catch (e, st) {
      log("❌ Error deleting product: $e");
      log("🧱 StackTrace: $st");
      return left(ServerFailure("Failed to delete product: ${e.toString()}"));
    }
  }
}
