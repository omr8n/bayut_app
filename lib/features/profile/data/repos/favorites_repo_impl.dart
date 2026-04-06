import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/profile/domain/repos/favorites_repo.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  final DatabaseService databaseService;

  FavoritesRepoImpl(this.databaseService);

  @override
  Future<Either<Failure, void>> toggleFavorite({
    required String userId,
    required String propertyId,
  }) async {
    try {
      // جلب بيانات المستخدم الحالية
      final userData = await databaseService.getData(
        path: BackendEndpoint.getUsersData,
        documentId: userId,
      );

      // التأكد من استخدام الحقل الصحيح للمفضلة (في الـ UserModel هو userWish)
      List<String> favorites = List<String>.from(userData['userWish'] ?? []);

      if (favorites.contains(propertyId)) {
        favorites.remove(propertyId);
      } else {
        favorites.add(propertyId);
      }

      await databaseService.updateData(
        path: BackendEndpoint.getUsersData,
        data: {'userWish': favorites},
        documentId: userId,
      );

      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<PropertyEntity>>> getFavoriteProperties(String userId) {
    return databaseService
        .streamData(path: BackendEndpoint.getUsersData)
        .asyncMap((event) async {
      try {
        // نستخدم uId بدلاً من id كما هو موجود في UserEntity/Model
        final userData = event.firstWhere(
          (element) => (element['uId'] ?? element['id']) == userId,
          orElse: () => throw Exception('User not found'),
        );
        // التوافق مع UserModel: نستخدم userWish
        List<String> favoriteIds = List<String>.from(userData['userWish'] ?? []);
        
        if (favoriteIds.isEmpty) return right(<PropertyEntity>[]);

        // جلب العقارات التي تطابق الـ IDs
        // ملاحظة: Firestore لا يدعم 'whereIn' مع الـ Streams بسهولة في هذه البنية، 
        // سنقوم بجلب كل العقارات ونفلترها أو نستخدم طريقة أخرى.
        // للأداء الأفضل في المشاريع الكبيرة يفضل Query محدد، لكن هنا سنتبع البساطة.
        
        final allPropertiesData = await databaseService.getCollectionDocuments(
          path: BackendEndpoint.getProperty,
        );
        
        final favoriteProperties = allPropertiesData
            .map((e) {
              // استخراج البيانات من الـ Snapshot وإضافة المعرف (id)
              final data = e.data();
              data['id'] = e.id; 
              return PropertyModel.fromJson(data).toEntity();
            })
            .where((element) => favoriteIds.contains(element.id))
            .toList();

        return right(favoriteProperties);
      } catch (e) {
        return left(ServerFailure(e.toString()));
      }
    });
  }
}
