import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/filter_widget.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/core/widgets/search_bar_widget.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';

// شاشة البحث
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Property> _filteredProperties = [];
  PropertyType? _selectedPropertyType;
  ListingType? _selectedListingType;
  double? _minPrice;
  double? _maxPrice;
  double? _minArea;
  double? _maxArea;
  String _sortBy = 'newest';

  @override
  void initState() {
    super.initState();
    _filteredProperties = MockData.properties;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredProperties = MockData.properties.where((property) {
        // فلترة البحث بالنص
        if (_searchController.text.isNotEmpty) {
          final searchLower = _searchController.text.toLowerCase();
          final titleMatch = property.title.toLowerCase().contains(searchLower);
          final locationMatch = property.location.toLowerCase().contains(
            searchLower,
          );
          if (!titleMatch && !locationMatch) return false;
        }

        // فلترة نوع العقار
        if (_selectedPropertyType != null &&
            property.type != _selectedPropertyType) {
          return false;
        }

        // فلترة نوع الإعلان
        if (_selectedListingType != null &&
            property.listingType != _selectedListingType) {
          return false;
        }

        // فلترة السعر
        if (_minPrice != null && property.price < _minPrice!) return false;
        if (_maxPrice != null && property.price > _maxPrice!) return false;

        // فلترة المساحة
        if (_minArea != null && property.area < _minArea!) return false;
        if (_maxArea != null && property.area > _maxArea!) return false;

        return true;
      }).toList();

      // الترتيب
      _sortProperties();
    });
  }

  void _sortProperties() {
    switch (_sortBy) {
      case 'newest':
        _filteredProperties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'priceLowToHigh':
        _filteredProperties.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'priceHighToLow':
        _filteredProperties.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'areaLargest':
        _filteredProperties.sort((a, b) => b.area.compareTo(a.area));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.search),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _sortProperties();
              });
            },
            icon: const Icon(Icons.sort),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'newest',
                child: Text(AppStrings.newest),
              ),
              const PopupMenuItem(
                value: 'priceLowToHigh',
                child: Text(AppStrings.priceLowToHigh),
              ),
              const PopupMenuItem(
                value: 'priceHighToLow',
                child: Text(AppStrings.priceHighToLow),
              ),
              const PopupMenuItem(
                value: 'areaLargest',
                child: Text(AppStrings.areaLargest),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (value) => _applyFilters(),
              onFilterTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => FilterWidget(
                    selectedPropertyType: _selectedPropertyType,
                    selectedListingType: _selectedListingType,
                    minPrice: _minPrice,
                    maxPrice: _maxPrice,
                    minArea: _minArea,
                    maxArea: _maxArea,
                    onApplyFilters:
                        ({
                          propertyType,
                          listingType,
                          minPrice,
                          maxPrice,
                          minArea,
                          maxArea,
                        }) {
                          setState(() {
                            _selectedPropertyType = propertyType;
                            _selectedListingType = listingType;
                            _minPrice = minPrice;
                            _maxPrice = maxPrice;
                            _minArea = minArea;
                            _maxArea = maxArea;
                          });
                          _applyFilters();
                        },
                  ),
                );
              },
            ),
          ),

          // عدد النتائج
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'تم العثور على ${_filteredProperties.length} عقار',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // قائمة العقارات
          Expanded(
            child: _filteredProperties.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = _filteredProperties[index];
                      return PropertyCard(
                        property: property,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyDetailsScreen(property: property),
                            ),
                          );
                        },
                        onFavorite: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت الإضافة للمفضلة'),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب تعديل معايير البحث',
            style: TextStyle(fontSize: 14, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
