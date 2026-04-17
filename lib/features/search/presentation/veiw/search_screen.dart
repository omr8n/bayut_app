import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/search_header.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/search_screen_bloc_builder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 🔥 جلب البيانات الخام فور دخول الصفحة لضمان الحداثة
    context.read<SearchCubit>().fetchAllPropertiesForSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // 🎯 حذفنا BlocProvider من هنا ليعتمد على العالمي في main.dart لضمان مزامنة الفلترة
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate(LangKeys.search)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              context.read<SearchCubit>().applyFilters(sortBy: value);
            },
            icon: const Icon(Icons.sort),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'newest',
                child: Text(localizations.translate(LangKeys.newest)),
              ),
              PopupMenuItem(
                value: 'priceLowToHigh',
                child: Text(localizations.translate(LangKeys.priceLowToHigh)),
              ),
              PopupMenuItem(
                value: 'priceHighToLow',
                child: Text(localizations.translate(LangKeys.priceHighToLow)),
              ),
              PopupMenuItem(
                value: 'areaLargest',
                child: Text(localizations.translate(LangKeys.areaLargest)),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<SearchCubit>().fetchAllPropertiesForSearch();
        },
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final cubit = context.read<SearchCubit>();
                  return SearchHeader(
                    controller: _searchController,
                    onChanged: (val) {
                      cubit.saveSearchHistory(val);
                      cubit.applyFilters(query: val);
                    },
                    onApply: ({
                      propertyType, listingType, minPrice, maxPrice, minArea, maxArea, governorate,
                      finishType, ownershipType, direction, heatingType, landType, farmType, irrigationType, poolType, minRooms, minBedrooms, minBathrooms, floorNumber, isLicensed, hasInstallment, isFeatured,
                    }) {
                      cubit.applyFilters(
                        propertyType: propertyType, listingType: listingType,
                        minPrice: minPrice, maxPrice: maxPrice,
                        minArea: minArea, maxArea: maxArea,
                        governorate: governorate, finishType: finishType,
                        minRooms: minRooms, isLicensed: isLicensed,
                        hasInstallment: hasInstallment, isFeatured: isFeatured,
                      );
                    },
                    // 🔥 تمرير الحالات من الكيوبيت لضمان بقاء العناصر المختارة ظاهرة في الـ UI
                    selectedPropertyType: cubit.currentPropertyType,
                    selectedListingType: cubit.currentListingType,
                    governorate: cubit.currentGovernorate,
                    minPrice: cubit.currentMinPrice,
                    maxPrice: cubit.currentMaxPrice,
                    minRooms: cubit.currentRooms,
                    isFeatured: cubit.currentFeatured,
                    isLicensed: cubit.currentLicensed,
                    hasInstallment: cubit.currentInstallment,
                  );
                },
              ),
            ),
            const SearchScreenBlocBuilder(),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
