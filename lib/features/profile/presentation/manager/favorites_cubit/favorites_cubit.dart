import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/profile/domain/repos/favorites_repo.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo favoritesRepo;
  final FirebaseAuthService authService;
  StreamSubscription? _favoritesSubscription;

  FavoritesCubit(this.favoritesRepo, this.authService)
    : super(FavoritesInitial());

  void resetState() {
    _favoritesSubscription?.cancel();
    emit(FavoritesInitial());
  }

  void getFavorites() {
    final user = authService.currentUser;
    if (user == null) {
      emit(FavoritesFailure('يجب تسجيل الدخول أولاً'));
      return;
    }

    emit(FavoritesLoading());
    _favoritesSubscription?.cancel();
    _favoritesSubscription = favoritesRepo
        .getFavoriteProperties(user.uid)
        .listen((result) {
          result.fold(
            (failure) => emit(FavoritesFailure(failure.message)),
            (properties) => emit(FavoritesLoaded(properties)),
          );
        });
  }

  Future<void> toggleFavorite(String propertyId) async {
    final user = authService.currentUser;
    if (user == null) {
      emit(FavoritesFailure('يجب تسجيل الدخول أولاً'));
      return;
    }

    // 1. التحديث المتفائل (Optimistic Update)
    // نحدث الحالة محلياً فوراً ليشعر المستخدم بالسرعة
    List<PropertyEntity> currentFavorites = [];
    if (state is FavoritesLoaded) {
      currentFavorites = List.from((state as FavoritesLoaded).favorites);
      final index = currentFavorites.indexWhere((p) => p.id == propertyId);
      
      if (index != -1) {
        currentFavorites.removeAt(index);
      } else {
        // إضافة عقار وهمي مؤقتاً بالـ ID فقط لكي يتلون القلب فوراً
        // سيتم استبداله بالبيانات الحقيقية عند وصول رد الفايربيس
        currentFavorites.add(PropertyEntity(
          id: propertyId,
          title: '',
          price: 0,
          images: const [],
          media: const [],
          listingType: ListingType.sale,
          area: 0,
          governorate: '',
          city: '',
          email: '',
          description: '',
          type: PropertyType.housesAndApartments,
          currency: 'SYP',
          createdAt: DateTime.now(),
          facilities: const [],
          location: '',
          phone: '',
          whatsapp: '',
          sellerId: '',
          sellerName: '',
        ));
      }
      emit(FavoritesLoaded(currentFavorites));
    }

    // 2. التنفيذ في الخلفية
    final result = await favoritesRepo.toggleFavorite(
      userId: user.uid,
      propertyId: propertyId,
    );

    result.fold((failure) {
      // 3. التراجع في حال الفشل
      getFavorites(); // إعادة المزامنة مع السيرفر
      emit(FavoritesFailure(failure.message));
    }, (_) {
      // النجاح: سيتم تحديث الـ Stream تلقائياً من الفايربيس
    });
  }

  bool isFavorite(String propertyId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favorites.any(
        (element) => element.id == propertyId,
      );
    }
    return false;
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
