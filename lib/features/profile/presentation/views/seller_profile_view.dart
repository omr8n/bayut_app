import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';

import 'seller_properties_view.dart';

class SellerProfileView extends StatefulWidget {
  final Property property;

  const SellerProfileView({super.key, required this.property});

  @override
  State<SellerProfileView> createState() => _SellerProfileViewState();
}

class _SellerProfileViewState extends State<SellerProfileView> {
  void _showAddRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AddRatingDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.property.sellerName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            _buildSellerHeader(context),
            const SizedBox(height: 10),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildEmptyState(),
                  _buildEmptyState(),
                  _buildEmptyState(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRatingDialog,
        backgroundColor: const Color(0xFFE3F2FD),
        elevation: 2,
        icon: const Icon(Icons.edit_note, color: Colors.blue),
        label: const Text(
          'إضافة تقييم',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSellerHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الانتقال لصفحة عقارات البائع
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SellerPropertiesView(sellerInfo: widget.property),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Color(0xFF0D47A1),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'العقارات',
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.property.sellerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.property.sellerJoinDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '0.0',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star_border,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '0 تقييمات',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFFE3F2FD),
                child: Text(
                  widget.property.sellerName[0],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: const TabBar(
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        tabs: [
          Tab(text: 'الكل (0)'),
          Tab(text: 'كبائع (0)'),
          Tab(text: 'كمشتري (0)'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        const Text(
          'لا توجد تقييمات بعد',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'كن أول من يقيم هذا المستخدم',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class AddRatingDialog extends StatefulWidget {
  const AddRatingDialog({super.key});

  @override
  State<AddRatingDialog> createState() => _AddRatingDialogState();
}

class _AddRatingDialogState extends State<AddRatingDialog> {
  int _selectedType = 0;
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.edit_square, color: Color(0xFF0D47A1)),
                const Text(
                  'إضافة تقييم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 24),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              ':نوع التقييم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildTypeOption(0, 'كبائع', Icons.store),
                const SizedBox(width: 12),
                _buildTypeOption(1, 'كمشتري', Icons.shopping_bag),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              ':التقييم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating
                        ? const Color(0xFF0D47A1)
                        : Colors.grey.shade300,
                    size: 35,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              ':التعليق (اختياري)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اكتب تعليقك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F5),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                    ),
                    child: const Text(
                      'إضافة',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(int index, String label, IconData icon) {
    bool isSelected = _selectedType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0D47A1)
                  : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
