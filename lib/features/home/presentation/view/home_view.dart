import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/no_network_widget.dart';
import 'package:test_graduation/core/widgets/search_field_widget.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/featuerd_properties_section.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/home_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/list_type_buttons_bloc_builder.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_properties_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // 🔥 تحديث يدوي: سيظهر شاشة الخطأ إذا لم يتوفر إنترنت
          await context.read<PropertyCubit>().fetchProperties(isRefresh: true);
        },
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: HomeHeader()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: SearchFieldWidget(
                  readOnly: true,
                  onTap: () {
                    context.push(AppRoutes.locationSearchPage);
                  },
                ),
              ),
            ),

            BlocBuilder<PropertyCubit, PropertyState>(
              builder: (context, state) {
                if (state is PropertyFailure) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: NoNetworkWidget(
                      showBanner: true,
                      onRetry: () {
                        context.read<PropertyCubit>().fetchProperties(
                          isRefresh: true,
                        );
                      },
                    ),
                  );
                }

                bool isOffline = false;
                if (state is PropertySuccess) {
                  isOffline = state.isOffline;
                }

                // في حالة النجاح (حتى لو أوفلاين) نظهر البيانات
                return MultiSliver(
                  children: [
                    if (isOffline)
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          color: Colors.orange.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.translate(LangKeys.offlineMode),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ListTypeButtonsBlocBuilder(),
                    FeatuerdPropertiesSection(),
                    RecentPropertiesSection(),
                  ],
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
