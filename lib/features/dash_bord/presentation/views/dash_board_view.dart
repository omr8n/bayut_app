// import 'package:flutter/material.dart';
// import 'package:test_graduation/features/dash_bord/presentation/widgets/dashboard_desktop_layout.dart';
// import 'package:test_graduation/features/dash_bord/presentation/widgets/dashboard_mobile_layout.dart';
// import 'package:test_graduation/features/dash_bord/presentation/widgets/dashboard_tablet_layout.dart';
// import 'package:test_graduation/features/dash_bord/presentation/widgets/side_menu.dart';

// import '../../../../core/utils/size_config.dart';

// import '../widgets/adaptive_layout.dart';

// class DashBoardView extends StatefulWidget {
//   const DashBoardView({super.key});
//   static const String routeName = '/';
//   @override
//   State<DashBoardView> createState() => _DashBoradViewState();
// }

// class _DashBoradViewState extends State<DashBoardView> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     // SizeConfig.init(context);
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: MediaQuery.sizeOf(context).width < SizeConfig.tablet
//           ? AppBar(
//               elevation: 0,
//               backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//               leading: IconButton(
//                 onPressed: () {
//                   scaffoldKey.currentState!.openDrawer();
//                 },
//                 icon: const Icon(Icons.menu),
//               ),
//             )
//           : null,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       drawer: MediaQuery.sizeOf(context).width < SizeConfig.tablet
//           ? const SideMenu()
//           : null,
//       body: AdaptiveLayout(
//         mobileLayout: (context) => const DashBoardMobileLayout(),
//         tabletLayout: (context) => const DashBoardTabletLayout(),
//         desktopLayout: (context) => const DashboardDesktopLayout(),
//       ),
//     );
//   }
// }
