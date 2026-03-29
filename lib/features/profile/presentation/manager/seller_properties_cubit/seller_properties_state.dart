import 'package:equatable/equatable.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

abstract class SellerPropertiesState extends Equatable {
  const SellerPropertiesState();

  @override
  List<Object?> get props => [];
}

class SellerPropertiesInitial extends SellerPropertiesState {}

class SellerPropertiesLoading extends SellerPropertiesState {}

class SellerPropertiesSuccess extends SellerPropertiesState {
  final List<PropertyEntity> properties;
  const SellerPropertiesSuccess(this.properties);

  @override
  List<Object?> get props => [properties];
}

class SellerPropertiesFailure extends SellerPropertiesState {
  final String errMessage;
  const SellerPropertiesFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
