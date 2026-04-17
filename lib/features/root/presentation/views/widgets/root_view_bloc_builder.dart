import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/features/root/presentation/manager/navigation_cubit.dart';
import 'package:test_graduation/features/root/presentation/views/widgets/root_view_body.dart';

import 'package:test_graduation/features/root/presentation/views/widgets/exit_warning_widget.dart';
import 'package:test_graduation/features/root/presentation/views/widgets/root_view_body.dart';

class RootViewBlocBuilder extends StatefulWidget {
  final List<Widget> screens;
  const RootViewBlocBuilder({super.key, required this.screens});

  @override
  State<RootViewBlocBuilder> createState() => _RootViewBlocBuilderState();
}

class _RootViewBlocBuilderState extends State<RootViewBlocBuilder> {
  DateTime? lastPressed;
  bool _showExitWarning = false;

  void _handleExitWarning() {
    setState(() => _showExitWarning = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showExitWarning = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (currentIndex != 0) {
              context.read<NavigationCubit>().changeIndex(0);
              return;
            }

            final now = DateTime.now();
            if (lastPressed == null ||
                now.difference(lastPressed!) > const Duration(seconds: 2)) {
              lastPressed = now;
              _handleExitWarning();
              return;
            }
            SystemNavigator.pop();
          },
          child: Stack(
            children: [
              RootViewBody(widget: widget, currentIndex: currentIndex),
              ExitWarningWidget(isVisible: _showExitWarning),
            ],
          ),
        );
      },
    );
  }
}
