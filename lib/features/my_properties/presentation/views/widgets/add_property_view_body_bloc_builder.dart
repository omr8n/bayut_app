import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_state.dart';

class AddPropertyViewBodyBlocBuilder extends StatelessWidget {
  const AddPropertyViewBodyBlocBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // 🔥 استخدام BlocConsumer هو الحل الآمن لضمان الرسم والسمع معاً
    return BlocConsumer<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        if (state is AddPropertySuccess) {
          Navigator.of(context).pop();
        }
        if (state is AddPropertyFailure) {
          MyAppMethods.showErrorORWarningDialog(
            context: context,
            subtitle: state.errMessage,
            fct: () {},
          );
        }
      },
      builder: (context, state) {
        // 🔥 مهما كانت الحالة (Loading, Success, Initial)
        // سنعرض دائماً الـ child (بيانات المستخدم) لكي لا تظهر شاشة سوداء
        return child;
      },
    );
  }
}
