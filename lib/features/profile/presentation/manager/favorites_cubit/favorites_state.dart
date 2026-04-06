import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<PropertyEntity> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesFailure extends FavoritesState {
  final String errMessage;
  FavoritesFailure(this.errMessage);
}

class FavoriteActionSuccess extends FavoritesState {
  final String message;
  FavoriteActionSuccess(this.message);
}
