import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/media_gallery.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_contact_buttons.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_facilities.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_location.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_main_info.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_seller.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_type_specific_details.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyEntity property;
  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  // int _currentMediaIndex = 0;
  bool _isFavorite = false;

  // bool _isVideo(String url) => url.toLowerCase().endsWith('.mp4');

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final mediaList = widget.property.media.isNotEmpty
        ? widget.property.media
        : widget.property.images;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              MediaGallery(media: mediaList),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PropertyDetailsHeader(
                        format: numberFormat,
                        property: widget.property,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.property.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      PropertyDetailsLocation(property: widget.property),
                      const SizedBox(height: 24),
                      PropertyDetailsMainInfo(property: widget.property),
                      const SizedBox(height: 24),
                      _buildSectionTitle(AppStrings.description),
                      Text(
                        widget.property.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      if (widget.property.facilities.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('المرافق والخدمات'),
                        PropertyDetailsFacilities(
                          facilities: widget.property.facilities,
                        ),
                      ],

                      PropertyTypeSpecificDetails(property: widget.property),

                      const SizedBox(height: 24),
                      PropertyDetailsSeller(property: widget.property),
                    ],
                  ),
                ),
              ),
            ],
          ),
          PropertyDetailsContactButtons(property: widget.property),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
