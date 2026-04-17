import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/features/root/presentation/manager/navigation_cubit.dart';
import 'package:test_graduation/features/root/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:test_graduation/features/root/presentation/views/widgets/root_view_bloc_builder.dart';

class RootViewBody extends StatelessWidget {
  const RootViewBody({
    super.key,
    required this.widget,
    required this.currentIndex,
  });
  final int currentIndex;
  final RootViewBlocBuilder widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: widget.screens),
      bottomNavigationBar: CustomBottonNavigationBar(
        selectedIndex: currentIndex,
        onTap: (index) => context.read<NavigationCubit>().changeIndex(index),
      ),
    );
  }
}
