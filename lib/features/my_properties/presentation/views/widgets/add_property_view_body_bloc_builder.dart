import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_state.dart';

class AddPropertyViewBodyBlocBuilder extends StatelessWidget {
  const AddPropertyViewBodyBlocBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        // 🔥 التعامل مع حالات النجاح (إضافة أو تعديل)
        if (state is AddPropertySuccess || state is UpdatePropertySuccess) {
          final bool isUpdate = state is UpdatePropertySuccess;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isUpdate
                    ? AppLocalizations.of(
                        context,
                      )!.translate(LangKeys.editSuccess)
                    : AppLocalizations.of(
                        context,
                      )!.translate(LangKeys.uploadSuccess),
              ),
              backgroundColor: AppColors.success,
            ),
          );

          // 🔥 طلبك: العودة لصفحة الـ Main مباشرة بعد النجاح
          // نستخدم pushReplacement لضمان عدم العودة لصفحة الإضافة عند الضغط على زر الرجوع
          GoRouter.of(context).pushReplacement(AppRoutes.mainScreen);
        } else if (state is AddPropertyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.translate(state.errMessage),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Stack(
        children: [
          child,
          BlocBuilder<AddPropertyCubit, AddPropertyState>(
            builder: (context, state) {
              if (state is AddPropertyLoading) {
                return Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
