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
  final List<PropertyEntity> featuredProperties;
  final List<PropertyEntity> recentProperties;

  const PropertySuccess({
    required this.featuredProperties,
    required this.recentProperties,
  });

  @override
  List<Object> get props => [featuredProperties, recentProperties];
}

class PropertyFailure extends PropertyState {
  final String errMessage;

  const PropertyFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}
