import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  Future<void> _makeCall() async {
    final Uri url = Uri.parse('tel:+963${widget.property.phone}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/963${widget.property.whatsapp}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildImageGallery(),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // السعر والنوع
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${numberFormat.format(widget.property.price)} ${widget.property.currency}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.property.listingType.arabicName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          _buildTypeBadge(),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // العنوان والموقع
                      Text(
                        widget.property.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${widget.property.governorate} - ${widget.property.city}\n${widget.property.location}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // التفاصيل الرئيسية
                      _buildMainDetailsRow(),
                      const SizedBox(height: 24),

                      // المعلومات القانونية والأساسية
                      _buildSectionTitle('المعلومات القانونية والأساسية'),
                      _buildBasicInfoSection(),
                      const SizedBox(height: 24),

                      // المواصفات التقنية الشاملة
                      _buildSectionTitle('المواصفات التفصيلية'),
                      _buildAllTechnicalSpecs(),
                      const SizedBox(height: 24),

                      // قسم التقسيط
                      if (widget.property.hasInstallment) ...[
                        _buildSectionTitle('معلومات التقسيط'),
                        _buildInstallmentSection(numberFormat),
                        const SizedBox(height: 24),
                      ],

                      // الوصف
                      _buildSectionTitle(AppStrings.description),
                      Text(
                        widget.property.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // المرافق
                      if (widget.property.facilities.isNotEmpty) ...[
                        _buildSectionTitle('المرافق والخدمات المتوفرة'),
                        _buildFacilitiesWrap(),
                        const SizedBox(height: 24),
                      ],

                      // معلومات البائع (تم نقلها إلى هنا بعد المرافق)
                      _buildSectionTitle('معلومات المعلن (البائع)'),
                      _buildSellerSection(),
                      const SizedBox(height: 24),

                      // إحصائيات
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'تاريخ النشر: ${dateFormat.format(widget.property.createdAt)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.visibility_outlined,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.property.views} مشاهدة',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildTopButtons(),
          _buildContactButtons(),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.property.type.arabicName,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildMainDetailsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (widget.property.totalRooms != null)
            _buildDetailItem(
              Icons.meeting_room_outlined,
              '${widget.property.totalRooms}',
              'غرف',
            ),
          if (widget.property.bedrooms != null)
            _buildDetailItem(
              Icons.bed_outlined,
              '${widget.property.bedrooms}',
              'نوم',
            ),
          if (widget.property.bathrooms != null)
            _buildDetailItem(
              Icons.bathroom_outlined,
              '${widget.property.bathrooms}',
              'حمامات',
            ),
          _buildDetailItem(
            Icons.square_foot,
            '${widget.property.area.toInt()}',
            'م²',
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (widget.property.buildingAge != null)
          _buildInfoChip(
            Icons.calendar_today,
            'عمر البناء: ${widget.property.buildingAge} سنة',
          ),
        if (widget.property.finishType != null)
          _buildInfoChip(
            Icons.format_paint,
            'الكسوة: ${widget.property.finishType}',
          ),
        if (widget.property.ownershipType != null)
          _buildInfoChip(
            Icons.assignment,
            'الملكية: ${widget.property.ownershipType}',
          ),
        if (widget.property.direction != null)
          _buildInfoChip(
            Icons.explore,
            'الاتجاه: ${widget.property.direction}',
          ),
        _buildInfoChip(
          widget.property.isLicensed ? Icons.verified : Icons.gavel,
          widget.property.isLicensed ? 'مرخص قانونياً' : 'غير مرخص',
        ),
      ],
    );
  }

  Widget _buildAllTechnicalSpecs() {
    final p = widget.property;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          if (p.floorNumber != null)
            _buildInfoListTile(Icons.layers, 'رقم الطابق', '${p.floorNumber}'),
          if (p.totalFloors != null)
            _buildInfoListTile(
              Icons.apartment,
              'إجمالي الطوابق',
              '${p.totalFloors}',
            ),
          if (p.heatingType != null)
            _buildInfoListTile(Icons.fireplace, 'نوع التدفئة', p.heatingType!),
          if (p.landType != null)
            _buildInfoListTile(Icons.terrain, 'صنف الأرض', p.landType!),
          if (p.frontagesCount != null)
            _buildInfoListTile(
              Icons.view_carousel,
              'عدد الواجهات',
              '${p.frontagesCount}',
            ),
          if (p.streetWidth != null)
            _buildInfoListTile(
              Icons.polyline,
              'عرض الشارع',
              '${p.streetWidth} متر',
            ),
          if (p.farmType != null)
            _buildInfoListTile(Icons.agriculture, 'نوع المزرعة', p.farmType!),
          if (p.irrigationType != null)
            _buildInfoListTile(Icons.waves, 'نوع الري', p.irrigationType!),
          if (p.crops != null)
            _buildInfoListTile(Icons.park, 'المحاصيل', p.crops!),
          if (p.frontageWidth != null)
            _buildInfoListTile(
              Icons.width_full,
              'عرض الواجهة',
              '${p.frontageWidth} متر',
            ),
          if (p.shopLocation != null)
            _buildInfoListTile(
              Icons.location_searching,
              'موقع المحل',
              p.shopLocation!,
            ),
          if (p.commercialActivity != null)
            _buildInfoListTile(
              Icons.business_center,
              'النشاط المسموح',
              p.commercialActivity!,
            ),
          if (p.poolType != null)
            _buildInfoListTile(Icons.pool, 'نوع المسبح', p.poolType!),
          if (p.poolSize != null)
            _buildInfoListTile(Icons.straighten, 'حجم المسبح', p.poolSize!),
          if (p.examinationRooms != null)
            _buildInfoListTile(
              Icons.medical_information,
              'غرف الكشف',
              '${p.examinationRooms}',
            ),
          if (p.medicalEquipment != null)
            _buildInfoListTile(
              Icons.medication,
              'التجهيزات الطبية',
              p.medicalEquipment!,
            ),
          if (p.warehouseHeight != null)
            _buildInfoListTile(
              Icons.height,
              'ارتفاع المستودع',
              '${p.warehouseHeight} متر',
            ),
          if (p.warehouseFloorType != null)
            _buildInfoListTile(
              Icons.layers_outlined,
              'أرضية المستودع',
              p.warehouseFloorType!,
            ),
          if (p.hallCapacity != null)
            _buildInfoListTile(
              Icons.people,
              'سعة الصالة',
              '${p.hallCapacity} شخص',
            ),
          if (p.workshopType != null)
            _buildInfoListTile(Icons.handyman, 'نوع الورشة', p.workshopType!),
          if (p.workshopHeight != null)
            _buildInfoListTile(
              Icons.height,
              'ارتفاع الورشة',
              '${p.workshopHeight} متر',
            ),
        ],
      ),
    );
  }

  Widget _buildSellerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.star, size: 16, color: AppColors.primary),
            label: const Text(
              'التقييمات',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.property.sellerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.property.sellerJoinDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              widget.property.sellerName[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentSection(NumberFormat format) {
    final p = widget.property;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildInfoListTile(
            Icons.payments,
            'الدفعة الأولى',
            '${format.format(p.downPayment ?? 0)} ${p.currency}',
          ),
          _buildInfoListTile(
            Icons.calendar_month,
            'القسط الشهري',
            '${format.format(p.monthlyInstallment ?? 0)} ${p.currency}',
          ),
          _buildInfoListTile(
            Icons.timer,
            'مدة التقسيط',
            '${p.installmentDuration} شهر',
          ),
          if (p.installmentNotes != null && p.installmentNotes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                p.installmentNotes!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.property.facilities
          .map(
            (f) => Chip(
              label: Text(f, style: const TextStyle(fontSize: 12)),
              avatar: const Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.success,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade200),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildInfoListTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            '$title:',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              itemCount: widget.property.images.length,
              onPageChanged: (i) => setState(() => _currentImageIndex = i),
              itemBuilder: (context, i) => Image.network(
                widget.property.images[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.background,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.property.images.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == i
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButtons() {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.arrow_back, () => Navigator.pop(context)),
          _buildIconButton(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            () => setState(() => _isFavorite = !_isFavorite),
            color: _isFavorite ? Colors.red : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Icon(icon, color: color ?? AppColors.textPrimary),
      ),
    );
  }

  Widget _buildContactButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _makeCall,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.success,
                ),
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text(
                  'اتصال الآن',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openWhatsApp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF25D366),
                ),
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  'واتساب',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
