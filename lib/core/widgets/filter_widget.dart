// import 'package:flutter/material.dart';
// import 'package:test_graduation/core/widgets/custom_primary_button.dart';
// import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
// import 'package:test_graduation/core/widgets/type_chip.dart';
// import '../models/property_model.dart';
// import '../utils/colors.dart';
// import '../utils/strings_ar.dart';

// // نافذة الفلترة
// class FilterWidget extends StatefulWidget {
//   final PropertyType? selectedPropertyType;
//   final ListingType? selectedListingType;
//   final double? minPrice;
//   final double? maxPrice;
//   final double? minArea;
//   final double? maxArea;
//   final Function({
//     PropertyType? propertyType,
//     ListingType? listingType,
//     double? minPrice,
//     double? maxPrice,
//     double? minArea,
//     double? maxArea,
//   })
//   onApplyFilters;

//   const FilterWidget({
//     super.key,
//     this.selectedPropertyType,
//     this.selectedListingType,
//     this.minPrice,
//     this.maxPrice,
//     this.minArea,
//     this.maxArea,
//     required this.onApplyFilters,
//   });

//   @override
//   State<FilterWidget> createState() => _FilterWidgetState();
// }

// class _FilterWidgetState extends State<FilterWidget> {
//   PropertyType? _selectedPropertyType;
//   ListingType? _selectedListingType;
//   final TextEditingController _minPriceController = TextEditingController();
//   final TextEditingController _maxPriceController = TextEditingController();
//   final TextEditingController _minAreaController = TextEditingController();
//   final TextEditingController _maxAreaController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _selectedPropertyType = widget.selectedPropertyType;
//     _selectedListingType = widget.selectedListingType;
//     if (widget.minPrice != null) {
//       _minPriceController.text = widget.minPrice!.toInt().toString();
//     }
//     if (widget.maxPrice != null) {
//       _maxPriceController.text = widget.maxPrice!.toInt().toString();
//     }
//     if (widget.minArea != null) {
//       _minAreaController.text = widget.minArea!.toInt().toString();
//     }
//     if (widget.maxArea != null) {
//       _maxAreaController.text = widget.maxArea!.toInt().toString();
//     }
//   }

//   @override
//   void dispose() {
//     _minPriceController.dispose();
//     _maxPriceController.dispose();
//     _minAreaController.dispose();
//     _maxAreaController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // العنوان
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 AppStrings.filters,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.close),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),

//           // نوع الإعلان
//           const Text(
//             'نوع الإعلان',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: TypeChip(
//                   label: AppStrings.forSale,
//                   isSelected: _selectedListingType == ListingType.sale,
//                   onTap: () =>
//                       setState(() => _selectedListingType = ListingType.sale),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: TypeChip(
//                   label: AppStrings.forRent,
//                   isSelected: _selectedListingType == ListingType.rent,
//                   onTap: () =>
//                       setState(() => _selectedListingType = ListingType.rent),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),

//           // نوع العقار
//           const Text(
//             AppStrings.propertyType,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: PropertyType.values.map((type) {
//               return TypeChip(
//                 label: type.arabicName,
//                 isSelected: _selectedPropertyType == type,
//                 onTap: () => setState(() => _selectedPropertyType = type),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 20),

//           // نطاق السعر
//           const Text(
//             AppStrings.priceRange,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: CustomTextFormField(
//                   controller: _minPriceController,
//                   hintText: AppStrings.minPrice,
//                   textAlign: TextAlign.right,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: CustomTextFormField(
//                   controller: _maxPriceController,
//                   hintText: AppStrings.maxPrice,
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),

//           // نطاق المساحة
//           const Text(
//             AppStrings.areaRange,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: CustomTextFormField(
//                   controller: _minAreaController,
//                   hintText: AppStrings.minArea,
//                   textAlign: TextAlign.right,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: CustomTextFormField(
//                   controller: _maxAreaController,
//                   hintText: AppStrings.maxArea,
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // الأزرار
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: _clearFilters,
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     side: const BorderSide(color: AppColors.primary),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'إعادة تعيين',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: CustomPriamryButton(
//                   onPressed: _applyFilters,
//                   title: 'تطبيق',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _clearFilters() {
//     setState(() {
//       _selectedPropertyType = null;
//       _selectedListingType = null;
//       _minPriceController.clear();
//       _maxPriceController.clear();
//       _minAreaController.clear();
//       _maxAreaController.clear();
//     });
//   }

//   void _applyFilters() {
//     widget.onApplyFilters(
//       propertyType: _selectedPropertyType,
//       listingType: _selectedListingType,
//       minPrice: _minPriceController.text.isEmpty
//           ? null
//           : double.tryParse(_minPriceController.text),
//       maxPrice: _maxPriceController.text.isEmpty
//           ? null
//           : double.tryParse(_maxPriceController.text),
//       minArea: _minAreaController.text.isEmpty
//           ? null
//           : double.tryParse(_minAreaController.text),
//       maxArea: _maxAreaController.text.isEmpty
//           ? null
//           : double.tryParse(_maxAreaController.text),
//     );
//     Navigator.pop(context);
//   }
// }
