import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'list_type_buttons.dart';

class ListTypeButtonsBlocBuilder extends StatelessWidget {
  const ListTypeButtonsBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        // نمرر البيانات للـ UI فقط إذا كانت الحالة Success
        // وإلا نمرر قوائم فارغة لكي لا يتوقف التصميم
        final List<PropertyEntity> saleProps = state is PropertySuccess
            ? state.saleProperties
            : [];
        final List<PropertyEntity> rentProps = state is PropertySuccess
            ? state.rentProperties
            : [];

        return ListTypeButtons(
          saleProperties: saleProps,
          rentProperties: rentProps,
        );
      },
    );
  }
}
