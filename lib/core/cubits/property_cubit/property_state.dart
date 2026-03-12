part of 'property_cubit.dart';

@immutable
abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertySuccess extends PropertyState {
  final List<PropertyEntity> properties; // 🔥 القائمة الشاملة لكل النتائج المطابقة (للبحث)
  final List<PropertyEntity> featuredProperties;
  final List<PropertyEntity> recentProperties;
  final List<PropertyEntity> saleProperties;
  final List<PropertyEntity> rentProperties;

  const PropertySuccess({
    required this.properties,
    required this.featuredProperties,
    required this.recentProperties,
    required this.saleProperties,
    required this.rentProperties,
  });

  @override
  List<Object> get props => [
        properties,
        featuredProperties,
        recentProperties,
        saleProperties,
        rentProperties,
      ];
}

class PropertyFailure extends PropertyState {
  final String errMessage;

  const PropertyFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}
