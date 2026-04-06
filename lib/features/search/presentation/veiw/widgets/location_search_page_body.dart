import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/search/presentation/manager/search_cubit/search_cubit.dart';

class LocationSearchPageBody extends StatefulWidget {
  final TextEditingController searchController;
  const LocationSearchPageBody({super.key, required this.searchController});

  @override
  State<LocationSearchPageBody> createState() => _LocationSearchPageBodyState();
}

class _LocationSearchPageBodyState extends State<LocationSearchPageBody> {
  String? selectedLoc;
  List<String> recentSearches = [];
  List<String> filteredGovernorates = [];

  @override
  void initState() {
    super.initState();
    filteredGovernorates = AppConstants.governorates;
    _loadAndSyncData();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = widget.searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        filteredGovernorates = AppConstants.governorates;
      } else {
        filteredGovernorates = AppConstants.governorates
            .where((loc) => loc.contains(query))
            .toList();
      }
      
      // إذا كان النص المكتوب يطابق تماماً محافظة، نختارها تلقائياً
      if (filteredGovernorates.contains(query)) {
        selectedLoc = query;
      }
    });
  }

  // 🔥 جلب سجل البحث ومزامنة الموقع الابتدائي بذكاء
  void _loadAndSyncData() {
    recentSearches = Prefs.getStringList('search_history') ?? [];

    //优先 جلب الموقع من الكيوبيت لضمان المزامنة مع الفلترة، ثم من Prefs
    final cubitLoc = context.read<SearchCubit>().currentGovernorate;
    final String initialLoc = cubitLoc ?? Prefs.getString('user_location');

    if (initialLoc.isNotEmpty && initialLoc != 'الكل') {
      setState(() {
        selectedLoc = initialLoc;
        widget.searchController.text = initialLoc;

        if (!recentSearches.contains(initialLoc)) {
          recentSearches.insert(0, initialLoc);
          if (recentSearches.length > 5) recentSearches.removeLast();
          Prefs.setStringList('search_history', recentSearches);
        }
      });
    } else {
      setState(() {
        selectedLoc = null;
        widget.searchController.text = '';
      });
    }
  }

  void _onLocationSelected(String loc) {
    setState(() {
      selectedLoc = loc;
      widget.searchController.text = loc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. سجل البحث (يظهر فوق المحافظات)
          if (recentSearches.isNotEmpty) ...[
            _buildSectionHeader(
              'المواقع التي تم البحث عنها مؤخراً',
              Icons.history,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: recentSearches
                  .take(7)
                  .map((s) => _buildRecentChip(s))
                  .toList(),
            ),
            const SizedBox(height: 30),
          ],

          // 2. المحافظات
          _buildSectionHeader(
            filteredGovernorates.isEmpty ? 'الموقع غير موجود' : 'المواقع المتاحة',
            filteredGovernorates.isEmpty ? Icons.error_outline : Icons.trending_up,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: filteredGovernorates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text(
                          'عذراً، هذا الموقع غير متوفر حالياً\nنحن نغطي المحافظات السورية فقط',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 16,
                      children: filteredGovernorates
                          .map((loc) => _buildLocationItem(loc))
                          .toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentChip(String label) {
    return GestureDetector(
      onTap: () => _onLocationSelected(label),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey[100],
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildLocationItem(String loc) {
    bool isSelected = selectedLoc == loc;
    return GestureDetector(
      onTap: () => _onLocationSelected(loc),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
          ),
        ),
        child: Text(
          loc,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => setState(() {
              widget.searchController.clear();
              selectedLoc = null;
            }),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'إعادة البحث',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Hero(
            tag: 'filter_hero',
            child: ElevatedButton(
              onPressed: () {
                final locToSave = selectedLoc ?? 'الكل';
                
                // 1. حفظ الموقع في الـ Cubit والـ Prefs لضمان توفره للفلترة
                Prefs.setString('user_location', locToSave);
                context.read<SearchCubit>().currentGovernorate = (locToSave == 'الكل') ? null : locToSave;

                // 2. التحقق من أين أتينا؟ 
                // سنستخدم محاولة الـ Pop، إذا نجحت ورجعنا للفلترة فهذا المطلوب.
                // لكن الأضمن هندسياً هو فحص الـ extra أو المسار.
                // هنا سنقوم بفتح الفلترة إذا كنا جايين من الـ Home
                
                final bool canPop = Navigator.of(context).canPop();
                
                // إذا كنا في صفحة الموقع وتم استدعاؤها من الفلترة، سنرجع بالـ Pop
                // لمعرفة ذلك، نتحقق من وجود صفحة الفلترة في مسار الراوتر
                if (canPop && GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString().contains(AppRoutes.filterScreen)) {
                   Navigator.of(context).pop(locToSave);
                } else {
                  // إذا جايين من الـ Home، نفتح صفحة الفلترة
                  context.pushReplacement(
                    AppRoutes.filterScreen,
                    extra: {'governorate': locToSave},
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005F5F),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'تم',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
