import 'package:equatable/equatable.dart';

abstract class AddPropertyState extends Equatable {
  const AddPropertyState();

  @override
  List<Object?> get props => [];
}

class AddPropertyInitial extends AddPropertyState {}

class AddPropertyLoading extends AddPropertyState {
  final String message;
  const AddPropertyLoading({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddPropertySuccess extends AddPropertyState {}

class AddPropertyFailure extends AddPropertyState {
  final String errMessage;
  const AddPropertyFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
