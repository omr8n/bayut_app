import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart'; // 🔥 استيراد
import 'package:test_graduation/core/data/mock_data.dart'; // 🔥 استيراد
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/profile/presentation/manager/seller_properties_cubit/seller_properties_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/seller_properties_cubit/seller_properties_state.dart';

class SellerPropertiesViewBlocBuilder extends StatelessWidget {
  const SellerPropertiesViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return BlocBuilder<SellerPropertiesCubit, SellerPropertiesState>(
      builder: (context, state) {
        if (state is SellerPropertiesSuccess) {
          if (state.properties.isEmpty) {
            return Center(
              child: Text(locale.translate(LangKeys.noPropertiesForSeller)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.properties.length,
            itemBuilder: (context, index) {
              return PropertyCard(property: state.properties[index]);
            },
          );
        } else if (state is SellerPropertiesFailure) {
          return Center(child: Text(locale.translate(state.errMessage)));
        } else {
          // 🔥 استخدام Skeletonizer لعقارات البائع أثناء التحميل
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return PropertyCard(property: MockData.properties.first);
              },
            ),
          );
        }
      },
    );
  }
}
