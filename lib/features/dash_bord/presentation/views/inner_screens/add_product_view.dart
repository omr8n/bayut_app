// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/add_product_cubit/add_product_cubit.dart';
// import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// import 'package:grocery_app_dashboard/core/repos/add_product_repo/add_products_repo.dart';
// import 'package:grocery_app_dashboard/core/repos/images_repo/images_repo.dart';
// import 'package:grocery_app_dashboard/core/services/get_it_service.dart';
// import 'package:grocery_app_dashboard/core/utils/size_config.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/add_product_view_body.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/add_product_view_body_bloc_builder.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/side_menu.dart';

// class AddProductView extends StatefulWidget {
//   static const routeName = '/UploadProductForm';

//   const AddProductView({super.key, this.productEntity});
//   final ProductEntity? productEntity;

//   @override
//   State<AddProductView> createState() => _AddProductViewState();
// }

// class _AddProductViewState extends State<AddProductView> {
//   late bool isEdit;

//   @override
//   void initState() {
//     super.initState();
//     isEdit = widget.productEntity != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//     // final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
//     final isTablet = MediaQuery.sizeOf(context).width >= SizeConfig.tablet;
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: !isTablet
//           ? AppBar(
//               elevation: 0,
//               backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//               leading: IconButton(
//                 onPressed: () => scaffoldKey.currentState?.openDrawer(),
//                 icon: const Icon(Icons.menu),
//               ),
//             )
//           : null,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       drawer: !isTablet ? const SideMenu() : null,
//       //   key: context.read<MenuController>().getAddProductscaffoldKey,
//       // drawer: const SideMenu(),
//       body: Row(
//         children: [
//           Expanded(flex: 1, child: const SideMenu()),
//           SizedBox(width: 32),
//           Expanded(
//             flex: 4,
//             child: AddProductsViewBodyBlocBuilder(
//               child: AddProductViewBody(
//                 isEdit: isEdit,
//                 productEntity: widget.productEntity,
//               ),
//             ),
//           ),
//         ],
//       ),

//       //isLoading: _isLoading,
//     );
//   }
// }
