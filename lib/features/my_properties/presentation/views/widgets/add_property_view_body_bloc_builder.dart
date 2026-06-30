import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_state.dart';

class AddPropertyViewBodyBlocBuilder extends StatelessWidget {
  const AddPropertyViewBodyBlocBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        // 🔥 العودة للخلف فوراً عند بدء الرفع
        if (state is AddPropertyInProgress) {
          GoRouter.of(context).pop();
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
