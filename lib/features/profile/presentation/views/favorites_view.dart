import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_state.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    // 🔥 طلب جلب البيانات فور فتح الصفحة
    context.read<FavoritesCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale!.translate(LangKeys.favorites),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    Icon(
                      Icons.favorite_border,
                      size: 80.sp,
                      color: isDark ? Colors.white12 : Colors.grey[300],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      locale.translate(
                        LangKeys.noResults,
                      ), // Or a more specific key if available
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey[600],
                      ),
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
            return Center(
              child: Text(
                state.errMessage,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
