import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/features/profile/domain/entities/rating_entity.dart';
import 'package:test_graduation/features/profile/domain/repos/rating_repo.dart';
import 'package:uuid/uuid.dart';
import 'package:test_graduation/core/helper/functions/get_user.dart';

import 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingRepo ratingRepo;
  StreamSubscription? _subscription;

  RatingCubit(this.ratingRepo) : super(RatingInitial());

  Future<void> addRating({
    required String sellerId,
    required double rating,
    required String comment,
  }) async {
    emit(RatingLoading());
    try {
      final user = await getUser();
      final ratingEntity = RatingEntity(
        id: const Uuid().v4(),
        sellerId: sellerId,
        raterId: user.uId,
        raterName: user.name,
        raterImage: user.profilePic,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      final result = await ratingRepo.addRating(ratingEntity);
      result.fold(
        (failure) => emit(RatingFailure(failure.message)),
        (_) => emit(RatingSuccess()),
      );
    } catch (e) {
      emit(RatingFailure('فشل التعرف على المستخدم: $e'));
    }
  }

  void fetchRatings(String sellerId) {
    emit(RatingLoading());
    _subscription?.cancel();
    _subscription = ratingRepo.getSellerRatings(sellerId).listen((result) {
      if (isClosed) return;
      result.fold(
        (failure) => emit(RatingFailure(failure.message)),
        (ratings) => emit(RatingsLoaded(ratings)),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
