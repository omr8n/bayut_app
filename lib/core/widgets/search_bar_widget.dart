import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'search_field_widget.dart';
import 'filter_button_widget.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 🔥 Expanded يجب أن يكون الأب المباشر للـ Hero هنا
          Expanded(
            child: Hero(
              tag: "Search",
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    // حقل البحث المنسق
                    const SearchFieldWidget(),

                    // طبقة شفافة تلتقط الضغط وتنقلك لصفحة المواقع
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.push(AppRoutes.locationSearchPage);
                        },
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔥 استخدام زر الفلتر المستقل
          if (onFilterTap != null) ...[
            const SizedBox(width: 12),
            FilterButtonWidget(onTap: onFilterTap!),
          ],
        ],
      ),
    );
  }
}
