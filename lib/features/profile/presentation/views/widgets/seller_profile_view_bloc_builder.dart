import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart'; // 🔥 استيراد
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/features/profile/domain/entities/rating_entity.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_state.dart';
import 'seller_empty_state.dart';
import 'rating_item.dart';

class SellerProfileViewBlocBuilder extends StatelessWidget {
  const SellerProfileViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        if (state is RatingsLoaded) {
          if (state.ratings.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: SellerEmptyState(),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.ratings.length,
            itemBuilder: (context, index) {
              return RatingItem(rating: state.ratings[index]);
            },
          );
        } else if (state is RatingFailure) {
          return Center(child: Text(locale.translate(state.message)));
        } else {
          // 🔥 استخدام Skeletonizer للتقييمات أثناء التحميل
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 3,
              itemBuilder: (context, index) {
                return RatingItem(
                  rating: RatingEntity(
                    id: '', sellerId: '', raterId: '', 
                    raterName: 'Fake User Name', 
                    rating: 5, comment: 'This is a long skeleton comment text for testing the loading experience...',
                    createdAt: DateTime.now(),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
