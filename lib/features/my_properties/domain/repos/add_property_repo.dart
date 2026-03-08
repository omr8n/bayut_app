import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/property_entity.dart';

abstract class AddPropertyRepo {
  // وظيفة إضافة عقار جديد
  Future<Either<Failure, String>> addProperty(PropertyEntity property);

  Future<Either<Failure, void>> editProperty(PropertyEntity property);
  // وظيفة جلب عقارات مستخدم معين
  //  Future<Either<Failure, List<PropertyEntity>>> getMyProperties(String userId);
}
