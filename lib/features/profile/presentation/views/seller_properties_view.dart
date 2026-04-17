import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

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
    final locale = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) =>
          getIt.get<SellerPropertiesCubit>()..fetchSellerProperties(sellerId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),
            appBar: AppBar(
              title: Text(
                '${locale.translate(LangKeys.sellerProperties)} $sellerName',
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  textDirection: locale.isEnLocale
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // 🔥 إضافة السحب للتحديث في بروفايل المعلن
            body: const SellerPropertiesViewBlocBuilder(),
          );
        },
      ),
    );
  }
}
