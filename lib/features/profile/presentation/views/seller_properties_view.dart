import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/profile/presentation/manager/seller_properties_cubit/seller_properties_cubit.dart';
import 'package:test_graduation/features/profile/presentation/views/widgets/seller_properties_view_bloc_builder.dart';

class SellerPropertiesView extends StatelessWidget {
  const SellerPropertiesView({
    super.key,
    required this.sellerId,
    required this.sellerName,
  });

  final String sellerId;
  final String sellerName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<SellerPropertiesCubit>()..fetchSellerProperties(sellerId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),
            appBar: AppBar(
              title: Text('عقارات $sellerName'),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // 🔥 إضافة السحب للتحديث في بروفايل المعلن
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<SellerPropertiesCubit>().fetchSellerProperties(sellerId);
                await Future.delayed(const Duration(seconds: 1));
              },
              color: AppColors.primary,
              backgroundColor: Colors.white,
              child: const SellerPropertiesViewBlocBuilder(),
            ),
          );
        }
      ),
    );
  }
}
