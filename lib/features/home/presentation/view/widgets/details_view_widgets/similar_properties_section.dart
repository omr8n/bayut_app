import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'similar_properties_widgets/no_similar_properties.dart';
import 'similar_properties_widgets/similar_properties_header.dart';
import 'similar_properties_widgets/similar_properties_list.dart';

class SimilarPropertiesSection extends StatelessWidget {
  final PropertyEntity currentProperty;

  const SimilarPropertiesSection({
    super.key,
    required this.currentProperty,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        if (state is PropertySuccess) {
          final similarProperties = _getSimilarProperties(state.properties);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SimilarPropertiesHeader(),
              if (similarProperties.isEmpty)
                const NoSimilarProperties()
              else
                SimilarPropertiesList(
                  similarProperties: similarProperties,
                ),
              SizedBox(height: 30.h),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<PropertyEntity> _getSimilarProperties(List<PropertyEntity> allProperties) {
    final similar = allProperties.where((p) {
      if (p.id == currentProperty.id) return false;

      // 1. شروط التطابق الأساسية (الموقع، النوع، الغرض)
      bool isBasicMatch = p.governorate == currentProperty.governorate &&
          p.type == currentProperty.type &&
          p.listingType == currentProperty.listingType;

      if (!isBasicMatch) return false;

      // 2. تقارب السعر (نطاق +/- 30%)
      double priceDiff = (p.price - currentProperty.price).abs();
      bool isPriceSimilar = priceDiff <= (currentProperty.price * 0.30);

      // 3. تقارب المساحة (نطاق +/- 30%)
      double areaDiff = (p.area - currentProperty.area).abs();
      bool isAreaSimilar = areaDiff <= (currentProperty.area * 0.30);

      return isPriceSimilar || isAreaSimilar;
    }).toList();

    // ترتيب النتائج بحيث يظهر الأكثر تشابهاً في السعر أولاً
    similar.sort((a, b) {
      double diffA = (a.price - currentProperty.price).abs();
      double diffB = (b.price - currentProperty.price).abs();
      return diffA.compareTo(diffB);
    });

    return similar;
  }
}
