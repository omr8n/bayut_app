import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class AdminPropertyCard extends StatelessWidget {
  final PropertyEntity property;
  final AdminCubit adminCubit;

  const AdminPropertyCard({
    super.key,
    required this.property,
    required this.adminCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                const SizedBox(width: 12),
                Expanded(child: _buildDetails()),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            property.sellerName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          _statusBadge(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: property.images.isNotEmpty
                  ? NetworkImage(property.images[0])
                  : const AssetImage('assets/images/placeholder.png')
                        as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (property.isFeatured)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, size: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 12,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              "${property.governorate}, ${property.city}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "${property.price} ${property.currency}",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            _statIcon(Icons.visibility_outlined, "${property.views}"),
          ],
        ),
      ],
    );
  }

  Widget _statIcon(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _statusBadge() {
    final bool isApproved = property.isApproved;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isApproved ? "معتمد" : "قيد المراجعة",
        style: TextStyle(
          color: isApproved ? Colors.green : Colors.orange,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionBtn(
            icon: property.isApproved
                ? Icons.unpublished_outlined
                : Icons.check_circle_outline,
            label: property.isApproved ? "إلغاء الاعتماد" : "اعتماد",
            color: property.isApproved ? Colors.orange : Colors.green,
            onTap: () => adminCubit.togglePropertyApproval(
              property.id,
              !property.isApproved,
              property.sellerId,
            ),
          ),
          _actionBtn(
            icon: property.isFeatured ? Icons.star : Icons.star_border,
            label: "تمييز",
            color: Colors.amber,
            onTap: () => adminCubit.togglePropertyFeatured(
              property.id,
              !property.isFeatured,
            ),
          ),
          _actionBtn(
            icon: Icons.delete_outline,
            label: "حذف",
            color: Colors.red,
            onTap: () => _showDeleteConfirm(context),
          ),
          _actionBtn(
            icon: Icons.open_in_new,
            label: "عرض",
            color: Colors.blue,
            onTap: () {
              // Navigate to property details
            },
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف العقار"),
        content: const Text("هل أنت متأكد من حذف هذا العقار نهائياً؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              adminCubit.deleteProperty(property.id, property.sellerId);
              Navigator.pop(context);
            },
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }
}
