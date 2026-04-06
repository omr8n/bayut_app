import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_state.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: AppColors.background,
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80.sp, color: Colors.grey[300]),
                    SizedBox(height: 16.h),
                    Text(
                      'قائمة المفضلة فارغة',
                      style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final property = state.favorites[index];
                return PropertyCard(
                  property: property,
                  onTap: (imgIndex) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailsScreen(
                          property: property,
                          initialIndex: imgIndex,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is FavoritesFailure) {
            return Center(child: Text(state.errMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
