import 'package:flutter/material.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  final bool isFavorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final PropertyEntity property;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // وظائف التواصل
  Future<void> _makeCall() async {
    final Uri url = Uri.parse('tel:${widget.property.phone}');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _sendWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/${widget.property.whatsapp}');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _sendEmail() async {
    final Uri url = Uri.parse('mailto:support@bayut.com?subject=استفسار عن عقار: ${widget.property.title}');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final images = widget.property.images.isNotEmpty ? widget.property.images : ['https://via.placeholder.com/800x450?text=No+Image'];

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. معرض الصور (Image Carousel)
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) => Image.network(images[index], fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey))),
                  ),
                ),
                // مؤشر النقاط (Dots)
                if (images.length > 1)
                  Positioned(
                    bottom: 12, left: 0, right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 6, height: 6,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: _currentImageIndex == index ? Colors.white : Colors.white.withOpacity(0.5)),
                      )),
                    ),
                  ),
                // ملصق الحالة (بيع/إيجار)
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: widget.property.listingType == ListingType.sale ? AppColors.forSale : AppColors.forRent, borderRadius: BorderRadius.circular(8)),
                    child: Text(widget.property.listingType.arabicName, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),

            // 2. المحتوى (نفس بيانات بيوت)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // السعر والعملة
                  Text('${numberFormat.format(widget.property.price)} ${widget.property.currency}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  // المواصفات (غرف، حمامات، مساحة)
                  Row(
                    children: [
                      if (widget.property.bedrooms != null) _buildInfoItem(Icons.bed_outlined, '${widget.property.bedrooms}'),
                      if (widget.property.bathrooms != null) _buildInfoItem(Icons.bathroom_outlined, '${widget.property.bathrooms}'),
                      _buildInfoItem(Icons.square_foot_outlined, '${widget.property.area.toInt()} م²'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // العنوان
                  Text(widget.property.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  // الموقع
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text('${widget.property.governorate} - ${widget.property.city}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                    ],
                  ),
                ],
              ),
            ),

            // 3. أزرار التواصل (WhatsApp, Call, Email)
            Container(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade100))),
              child: Row(
                children: [
                  _buildActionButton('واتساب', Icons.chat_bubble_outline, const Color(0xFF25D366), _sendWhatsApp),
                  _buildActionButton('اتصال', Icons.phone_outlined, AppColors.success, _makeCall),
                  _buildActionButton('الإيميل', Icons.email_outlined, Colors.blue, _sendEmail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
