import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'admin_properties_header.dart';
import 'admin_properties_stats.dart';
import 'admin_properties_list.dart';

class AdminPropertiesViewBody extends StatefulWidget {
  const AdminPropertiesViewBody({super.key});

  @override
  State<AdminPropertiesViewBody> createState() =>
      _AdminPropertiesViewBodyState();
}

class _AdminPropertiesViewBodyState extends State<AdminPropertiesViewBody> {
  String searchQuery = '';
  ListingType? selectedType;
  String? extraFilter;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchProperties(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AdminCubit>().fetchProperties();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final currentExtraFilter = extraFilter ?? local.all;

    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(local.translate(state.errMessage)),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is AdminActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AdminLoading;

        if (state is AdminPropertiesSuccess || isLoading) {
          final properties = state is AdminPropertiesSuccess
              ? state.properties
              : <PropertyEntity>[];

          List<PropertyEntity> filteredList = properties.where((property) {
            final matchesSearch =
                property.title.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                property.location.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                );
            final matchesType =
                selectedType == null || property.listingType == selectedType;

            bool matchesExtra = true;
            if (currentExtraFilter == local.premium_requests) {
              matchesExtra = property.premiumStatus == PremiumStatus.pending;
            } else if (currentExtraFilter == local.currently_featured) {
              matchesExtra = property.premiumStatus == PremiumStatus.active;
            } else if (currentExtraFilter == local.trend_leaders) {
              // Assume top 5 views for now
              matchesExtra = true;
            }

            return matchesSearch && matchesType && matchesExtra;
          }).toList();

          if (currentExtraFilter == local.trend_leaders) {
            filteredList.sort((a, b) => b.views.compareTo(a.views));
            filteredList = filteredList.take(5).toList();
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                if (isLoading)
                  const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: AppColors.primary,
                    minHeight: 3,
                  ),
                AdminPropertiesHeader(
                  onSearchChanged: (val) => setState(() => searchQuery = val),
                  onFilterChanged: (type) =>
                      setState(() => selectedType = type),
                  onExtraFilterChanged: (val) =>
                      setState(() => extraFilter = val),
                ),

                // Original 4 stats
                AdminPropertiesStats(properties: properties),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<AdminCubit>().fetchProperties(isRefresh: true);
                    },
                    color: AppColors.primary,
                    child: AdminPropertiesList(
                      properties: filteredList,
                      extraFilter: currentExtraFilter,
                      scrollController: _scrollController,
                      isLoadingMore: state is AdminPropertiesSuccess && !state.hasReachedMax,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(child: Text(local.loading));
      },
    );
  }
}
