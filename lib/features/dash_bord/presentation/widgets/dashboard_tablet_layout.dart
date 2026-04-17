import 'package:flutter/material.dart';

import 'package:test_graduation/features/dash_bord/presentation/widgets/side_menu.dart';

import 'dashboard_mobile_layout.dart';

class DashBoardTabletLayout extends StatelessWidget {
  const DashBoardTabletLayout({super.key, this.flex = 3});
  final int flex;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SideMenu()),
        SizedBox(width: 32),
        Expanded(
          flex: flex,
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: DashBoardMobileLayout(),
          ),
        ),
        SizedBox(width: 32),
      ],
    );
  }
}
