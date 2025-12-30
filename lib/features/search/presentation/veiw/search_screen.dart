import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/empty_state.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/search_header.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/search_results_count.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/search_results_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Property> _filteredProperties = [];

  // حالات الفلترة الشاملة
  PropertyType? _selectedPropertyType;
  ListingType? _selectedListingType;
  double? _minPrice;
  double? _maxPrice;
  double? _minArea;
  double? _maxArea;
  String? _governorate;
  String? _finishType;
  String? _ownershipType;
  String? _direction;
  String? _heatingType;
  String? _landType;
  String? _farmType;
  String? _irrigationType;
  String? _poolType;
  int? _minRooms;
  int? _minBedrooms;
  int? _minBathrooms;
  int? _floorNumber;
  bool? _isLicensed;
  bool? _hasInstallment;

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
        // البحث بالنص
        if (_searchController.text.isNotEmpty) {
          final searchLower = _searchController.text.toLowerCase();
          final titleMatch = property.title.toLowerCase().contains(searchLower);
          final locationMatch = property.location.toLowerCase().contains(searchLower);
          if (!titleMatch && !locationMatch) return false;
        }

        // الفلاتر الأساسية
        if (_selectedPropertyType != null && property.type != _selectedPropertyType) return false;
        if (_selectedListingType != null && property.listingType != _selectedListingType) return false;
        if (_minPrice != null && property.price < _minPrice!) return false;
        if (_maxPrice != null && property.price > _maxPrice!) return false;
        if (_minArea != null && property.area < _minArea!) return false;
        if (_maxArea != null && property.area > _maxArea!) return false;

        // الفلاتر المتقدمة
        if (_governorate != null && property.governorate != _governorate) return false;
        if (_finishType != null && property.finishType != _finishType) return false;
        if (_ownershipType != null && property.ownershipType != _ownershipType) return false;
        if (_direction != null && property.direction != _direction) return false;
        if (_heatingType != null && property.heatingType != _heatingType) return false;
        if (_landType != null && property.landType != _landType) return false;
        if (_farmType != null && property.farmType != _farmType) return false;
        if (_irrigationType != null && property.irrigationType != _irrigationType) return false;
        if (_poolType != null && property.poolType != _poolType) return false;

        // فلاتر الأرقام
        if (_minRooms != null && (property.totalRooms ?? 0) < _minRooms!) return false;
        if (_minBedrooms != null && (property.bedrooms ?? 0) < _minBedrooms!) return false;
        if (_minBathrooms != null && (property.bathrooms ?? 0) < _minBathrooms!) return false;
        if (_floorNumber != null && property.floorNumber != _floorNumber) return false;

        // فلاتر بوليان
        if (_isLicensed != null && property.isLicensed != _isLicensed) return false;
        if (_hasInstallment != null && property.hasInstallment != _hasInstallment) return false;

        return true;
      }).toList();

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
              const PopupMenuItem(value: 'newest', child: Text(AppStrings.newest)),
              const PopupMenuItem(value: 'priceLowToHigh', child: Text(AppStrings.priceLowToHigh)),
              const PopupMenuItem(value: 'priceHighToLow', child: Text(AppStrings.priceHighToLow)),
              const PopupMenuItem(value: 'areaLargest', child: Text(AppStrings.areaLargest)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SearchHeader(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            onApply: ({
              propertyType, listingType, minPrice, maxPrice, minArea, maxArea,
              governorate, finishType, ownershipType, direction, heatingType,
              landType, farmType, irrigationType, poolType, minRooms, minBedrooms,
              minBathrooms, floorNumber, isLicensed, hasInstallment
            }) {
              setState(() {
                _selectedPropertyType = propertyType;
                _selectedListingType = listingType;
                _minPrice = minPrice;
                _maxPrice = maxPrice;
                _minArea = minArea;
                _maxArea = maxArea;
                _governorate = governorate;
                _finishType = finishType;
                _ownershipType = ownershipType;
                _direction = direction;
                _heatingType = heatingType;
                _landType = landType;
                _farmType = farmType;
                _irrigationType = irrigationType;
                _poolType = poolType;
                _minRooms = minRooms;
                _minBedrooms = minBedrooms;
                _minBathrooms = minBathrooms;
                _floorNumber = floorNumber;
                _isLicensed = isLicensed;
                _hasInstallment = hasInstallment;
              });
              _applyFilters();
            },
            selectedPropertyType: _selectedPropertyType,
            selectedListingType: _selectedListingType,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
            minArea: _minArea,
            maxArea: _maxArea,
            governorate: _governorate,
            finishType: _finishType,
            ownershipType: _ownershipType,
            direction: _direction,
            heatingType: _heatingType,
            landType: _landType,
            farmType: _farmType,
            irrigationType: _irrigationType,
            poolType: _poolType,
            minRooms: _minRooms,
            minBedrooms: _minBedrooms,
            minBathrooms: _minBathrooms,
            floorNumber: _floorNumber,
            isLicensed: _isLicensed,
            hasInstallment: _hasInstallment,
          ),
          SearchResultsCount(count: _filteredProperties.length),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredProperties.isEmpty
                ? const EmptyState()
                : SearchResultsList(properties: _filteredProperties),
          ),
        ],
      ),
    );
  }
}
