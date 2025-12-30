// import 'package:flutter/material.dart';
// import 'package:test_graduation/core/widgets/custom_primary_button.dart';
// import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
// import 'package:test_graduation/core/widgets/type_chip.dart';
// import '../models/property_model.dart';
// import '../utils/colors.dart';
// import '../utils/strings_ar.dart';

// class FilterWidget extends StatefulWidget {
//   final PropertyType? selectedPropertyType;
//   final ListingType? selectedListingType;
//   final double? minPrice;
//   final double? maxPrice;
//   final double? minArea;
//   final double? maxArea;
//   final String? selectedGovernorate;
//   final String? selectedFinishType;
//   final int? minRooms;

//   final Function({
//     PropertyType? propertyType,
//     ListingType? listingType,
//     double? minPrice,
//     double? maxPrice,
//     double? minArea,
//     double? maxArea,
//     String? governorate,
//     String? finishType,
//     int? minRooms,
//   }) onApplyFilters;

//   const FilterWidget({
//     super.key,
//     this.selectedPropertyType,
//     this.selectedListingType,
//     this.minPrice,
//     this.maxPrice,
//     this.minArea,
//     this.maxArea,
//     this.selectedGovernorate,
//     this.selectedFinishType,
//     this.minRooms,
//     required this.onApplyFilters,
//   });

//   @override
//   State<FilterWidget> createState() => _FilterWidgetState();
// }

// class _FilterWidgetState extends State<FilterWidget> {
//   PropertyType? _selectedPropertyType;
//   ListingType? _selectedListingType;
//   String? _selectedGovernorate;
//   String? _selectedFinishType;
  
//   final TextEditingController _minPriceController = TextEditingController();
//   final TextEditingController _maxPriceController = TextEditingController();
//   final TextEditingController _minAreaController = TextEditingController();
//   final TextEditingController _maxAreaController = TextEditingController();
//   final TextEditingController _minRoomsController = TextEditingController();

//   final List<String> _governorates = ['الكل', 'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس'];
//   final List<String> _finishTypes = ['الكل', 'سوبر ديلوكس', 'ديلوكس', 'عادي', 'على العظم', 'قديم'];

//   @override
//   void initState() {
//     super.initState();
//     _selectedPropertyType = widget.selectedPropertyType;
//     _selectedListingType = widget.selectedListingType;
//     _selectedGovernorate = widget.selectedGovernorate ?? 'الكل';
//     _selectedFinishType = widget.selectedFinishType ?? 'الكل';
    
//     if (widget.minPrice != null) _minPriceController.text = widget.minPrice!.toInt().toString();
//     if (widget.maxPrice != null) _maxPriceController.text = widget.maxPrice!.toInt().toString();
//     if (widget.minArea != null) _minAreaController.text = widget.minArea!.toInt().toString();
//     if (widget.maxArea != null) _maxAreaController.text = widget.maxArea!.toInt().toString();
//     if (widget.minRooms != null) _minRoomsController.text = widget.minRooms.toString();
//   }

//   @override
//   void dispose() {
//     _minPriceController.dispose();
//     _maxPriceController.dispose();
//     _minAreaController.dispose();
//     _maxAreaController.dispose();
//     _minRoomsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // العنوان
//             _buildHeader(),
//             const SizedBox(height: 20),

//             // نوع الإعلان
//             _buildSectionTitle('الغرض من العقار'),
//             Row(
//               children: [
//                 Expanded(child: TypeChip(label: AppStrings.forSale, isSelected: _selectedListingType == ListingType.sale, onTap: () => setState(() => _selectedListingType = ListingType.sale))),
//                 const SizedBox(width: 12),
//                 Expanded(child: TypeChip(label: AppStrings.forRent, isSelected: _selectedListingType == ListingType.rent, onTap: () => setState(() => _selectedListingType = ListingType.rent))),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // المحافظة
//             _buildSectionTitle('الموقع (المحافظة)'),
//             _buildDropdownField(_governorates, _selectedGovernorate, (val) => setState(() => _selectedGovernorate = val)),
//             const SizedBox(height: 20),

//             // نوع العقار
//             _buildSectionTitle(AppStrings.propertyType),
//             Wrap(
//               spacing: 8, runSpacing: 8,
//               children: PropertyType.values.map((type) {
//                 return TypeChip(label: type.arabicName, isSelected: _selectedPropertyType == type, onTap: () => setState(() => _selectedPropertyType = type));
//               }).toList(),
//             ),
//             const SizedBox(height: 20),

//             // نطاق السعر والمساحة
//             _buildSectionTitle('الميزانية والمساحة'),
//             Row(
//               children: [
//                 Expanded(child: CustomTextFormField(controller: _minPriceController, hintText: 'أقل سعر', textAlign: TextAlign.right, keyboardType: TextInputType.number)),
//                 const SizedBox(width: 12),
//                 Expanded(child: CustomTextFormField(controller: _maxPriceController, hintText: 'أعلى سعر', textAlign: TextAlign.right, keyboardType: TextInputType.number)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(child: CustomTextFormField(controller: _minAreaController, hintText: 'أقل مساحة', textAlign: TextAlign.right, keyboardType: TextInputType.number)),
//                 const SizedBox(width: 12),
//                 Expanded(child: CustomTextFormField(controller: _maxAreaController, hintText: 'أعلى مساحة', textAlign: TextAlign.right, keyboardType: TextInputType.number)),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // الكسوة والغرف
//             _buildSectionTitle('تفاصيل إضافية'),
//             _buildDropdownField(_finishTypes, _selectedFinishType, (val) => setState(() => _selectedFinishType = val)),
//             const SizedBox(height: 12),
//             CustomTextFormField(controller: _minRoomsController, labelText: 'الحد الأدنى للغرف', textAlign: TextAlign.right, prefixIcon: Icons.meeting_room_outlined, keyboardType: TextInputType.number),
            
//             const SizedBox(height: 30),

//             // أزرار التحكم
//             Row(
//               children: [
//                 Expanded(child: OutlinedButton(onPressed: _clearFilters, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('إعادة تعيين', style: TextStyle(fontWeight: FontWeight.bold)))),
//                 const SizedBox(width: 12),
//                 Expanded(child: CustomPriamryButton(onPressed: _applyFilters, title: 'تطبيق الفلتر')),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(AppStrings.filters, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
//         IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, size: 28)),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
//     );
//   }

//   Widget _buildDropdownField(List<String> items, String? value, Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       isExpanded: true,
//       decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300))),
//       items: items.map((String val) => DropdownMenuItem<String>(value: val, alignment: AlignmentDirectional.centerEnd, child: Text(val, textAlign: TextAlign.right))).toList(),
//       onChanged: onChanged,
//     );
//   }

//   void _clearFilters() {
//     setState(() {
//       _selectedPropertyType = null;
//       _selectedListingType = null;
//       _selectedGovernorate = 'الكل';
//       _selectedFinishType = 'الكل';
//       _minPriceController.clear();
//       _maxPriceController.clear();
//       _minAreaController.clear();
//       _maxAreaController.clear();
//       _minRoomsController.clear();
//     });
//   }

//   void _applyFilters() {
//     widget.onApplyFilters(
//       propertyType: _selectedPropertyType,
//       listingType: _selectedListingType,
//       governorate: _selectedGovernorate == 'الكل' ? null : _selectedGovernorate,
//       finishType: _selectedFinishType == 'الكل' ? null : _selectedFinishType,
//       minPrice: double.tryParse(_minPriceController.text),
//       maxPrice: double.tryParse(_maxPriceController.text),
//       minArea: double.tryParse(_minAreaController.text),
//       maxArea: double.tryParse(_maxAreaController.text),
//       minRooms: int.tryParse(_minRoomsController.text),
//     );
//     Navigator.pop(context);
//   }
// }
