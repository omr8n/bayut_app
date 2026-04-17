import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'admin_properties_header.dart';
import 'admin_properties_stats.dart';
import 'admin_properties_list.dart';

class AdminPropertiesViewBody extends StatefulWidget {
  const AdminPropertiesViewBody({super.key});

  @override
  State<AdminPropertiesViewBody> createState() => _AdminPropertiesViewBodyState();
}

class _AdminPropertiesViewBodyState extends State<AdminPropertiesViewBody> {
  String searchQuery = '';
  ListingType? selectedType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.translate(state.errMessage)),
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
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminPropertiesSuccess) {
          // نفس منطق الفلترة الأصلي الخاص بك (بيع / إيجار)
          List<PropertyEntity> filteredList = state.properties.where((property) {
            final matchesSearch = property.title.toLowerCase().contains(searchQuery.toLowerCase()) || 
                                property.location.toLowerCase().contains(searchQuery.toLowerCase());
            final matchesType = selectedType == null || property.listingType == selectedType;
            return matchesSearch && matchesType;
          }).toList();

          return Column(
            children: [
              // الهيدر الأزرق المنحني (الجديد في الشكل، القديم في الكبسات)
              AdminPropertiesHeader(
                onSearchChanged: (val) => setState(() => searchQuery = val),
                onFilterChanged: (type) => setState(() => selectedType = type),
              ),
              
              // الإحصائيات الأربعة الأصلية (لم تُحذف وبقيت في مكانها)
              AdminPropertiesStats(properties: state.properties),

              Expanded(
                child: AdminPropertiesList(properties: filteredList),
              ),
            ],
          );
        }

        return const Center(child: Text("جاري تحميل البيانات..."));
      },
    );
  }
}
