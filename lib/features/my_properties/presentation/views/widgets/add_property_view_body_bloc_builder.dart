import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_state.dart';

class AddPropertyViewBodyBlocBuilder extends StatelessWidget {
  const AddPropertyViewBodyBlocBuilder({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        if (state is AddPropertySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تمت العملية بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }

        if (state is AddPropertyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // نمرر النص الموجود داخل الـ state لإظهاره للمستخدم
        String? loadingMessage;
        if (state is AddPropertyLoading) {
          loadingMessage = state.message;
        }

        return LoadingManager(
          isLoading: state is AddPropertyLoading,
          message: loadingMessage, // عرض الرسالة (مثل: جاري رفع الملف 1 من 3)
          child: child,
        );
      },
    );
  }
}
