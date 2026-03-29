import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_cubit.dart';
import 'widgets/seller_header.dart';
import 'widgets/seller_profile_view_bloc_builder.dart';

class SellerProfileView extends StatelessWidget {
  final PropertyEntity property;

  const SellerProfileView({super.key, required this.property});

  void _handleRatingAction(BuildContext context) {
    final bool isLoggedIn = SecureStorage.isLoggedIn;

    if (isLoggedIn) {
      MyAppMethods.showAddRatingDialog(context, sellerId: property.sellerId);
    } else {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: 'يرجى تسجيل الدخول أولاً لتتمكن من تقييم المعلن',
        fct: () {
          // يمكن إضافة التوجيه لصفحة تسجيل الدخول هنا
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 توفير الكيوبيت للشاشة بالكامل (MVVM)
    return BlocProvider(
      create: (context) =>
          getIt.get<RatingCubit>()..fetchRatings(property.sellerId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'ملف المعلن',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SellerHeader(property: property),
              const SizedBox(height: 16),
              _buildSectionTitle('آراء وتجارب المستخدمين'),
              // 🔥 استدعاء المحرك الذكي
              const SellerProfileViewBlocBuilder(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        // 🔥 التصحيح: استخدام Builder لتوفير context يحتوي على الـ BlocProvider
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _handleRatingAction(context),
          backgroundColor: const Color(0xFFE3F2FD),
          elevation: 2,
          icon: const Icon(Icons.star_rate_rounded, color: Colors.blue),
          label: const Text(
            'تقييم المعلن',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
