import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/search_header.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/search_screen_bloc_builder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // حالات الفلترة والترتيب
  PropertyType? _selectedPropertyType;
  ListingType? _selectedListingType;
  double? _minPrice, _maxPrice, _minArea, _maxArea;
  String? _governorate;
  String _sortBy = 'newest';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🔥 وظيفة مركزية لتحديث الفلاتر في الكيوبيت
  void _triggerFilter(BuildContext context) {
    context.read<PropertyCubit>().applyFilters(
      query: _searchController.text,
      propertyType: _selectedPropertyType,
      listingType: _selectedListingType,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minArea: _minArea,
      maxArea: _maxArea,
      governorate: _governorate,
      sortBy: _sortBy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<PropertyCubit>()..fetchProperties(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(AppStrings.search),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() => _sortBy = value);
                  _triggerFilter(context);
                },
                icon: const Icon(Icons.sort),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'newest', child: Text(AppStrings.newest)),
                  const PopupMenuItem(value: 'priceLowToHigh', child: Text(AppStrings.priceLowToHigh)),
                  const PopupMenuItem(value: 'priceHighToLow', child: Text(AppStrings.priceHighToLow)),
                  const PopupMenuItem(value: 'areaLargest', child: Text(AppStrings.areaLargest)),
                ],
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            // 1. قسم رأس البحث والفلاتر
            SliverToBoxAdapter(
              child: Builder(
                builder: (context) => SearchHeader(
                  controller: _searchController,
                  onChanged: (_) => _triggerFilter(context),
                  onApply: ({
                    PropertyType? propertyType, ListingType? listingType,
                    minPrice, maxPrice, minArea, maxArea, governorate,
                    finishType, ownershipType, direction, heatingType, landType, farmType, irrigationType, poolType, minRooms, minBedrooms, minBathrooms, floorNumber, isLicensed, hasInstallment,
                  }) {
                    setState(() {
                      _selectedPropertyType = propertyType;
                      _selectedListingType = listingType;
                      _minPrice = minPrice;
                      _maxPrice = maxPrice;
                      _minArea = minArea;
                      _maxArea = maxArea;
                      _governorate = governorate;
                    });
                    _triggerFilter(context);
                  },
                  selectedPropertyType: _selectedPropertyType,
                  selectedListingType: _selectedListingType,
                  minPrice: _minPrice, maxPrice: _maxPrice,
                  minArea: _minArea, maxArea: _maxArea,
                  governorate: _governorate,
                ),
              ),
            ),

            // 2. قسم النتائج (المنفصل تماماً والاحترافي)
            const SearchScreenBlocBuilder(),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
