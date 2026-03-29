import 'package:equatable/equatable.dart';
import 'package:test_graduation/features/profile/domain/entities/rating_entity.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {}

class RatingsLoaded extends RatingState {
  final List<RatingEntity> ratings;
  const RatingsLoaded(this.ratings);

  @override
  List<Object?> get props => [ratings];
}

class RatingFailure extends RatingState {
  final String message;
  const RatingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
