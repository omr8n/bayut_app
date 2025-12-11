// import 'package:flutter/material.dart';
// import 'package:test_graduation/core/models/property_model.dart';
// import 'package:test_graduation/core/utils/colors.dart';
// import 'package:test_graduation/core/utils/strings_ar.dart';
// import 'package:test_graduation/core/widgets/custom_primary_button.dart';
// import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
// import 'package:test_graduation/core/widgets/type_chip.dart';

// // شاشة إضافة عقار
// class AddPropertyScreen extends StatefulWidget {
//   const AddPropertyScreen({super.key});

//   @override
//   State<AddPropertyScreen> createState() => _AddPropertyScreenState();
// }

// class _AddPropertyScreenState extends State<AddPropertyScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _areaController = TextEditingController();
//   final TextEditingController _bedroomsController = TextEditingController();
//   final TextEditingController _bathroomsController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();

//   PropertyType _selectedPropertyType = PropertyType.apartment;
//   ListingType _selectedListingType = ListingType.sale;
//   bool _isFeatured = false;

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _priceController.dispose();
//     _areaController.dispose();
//     _bedroomsController.dispose();
//     _bathroomsController.dispose();
//     _locationController.dispose();
//     _cityController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(AppStrings.addProperty),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 'المعلومات الأساسية',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // عنوان العقار
//                     CustomTextFormField(
//                       controller: _titleController,
//                       textAlign: TextAlign.right,
//                       labelText: 'عنوان العقار',
//                       hintText: 'مثل: شقة فاخرة في دبي',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'يرجى إدخال العنوان';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // الوصف
//                     CustomTextFormField(
//                       controller: _descriptionController,
//                       textAlign: TextAlign.right,
//                       maxLines: 4,
//                       labelText: AppStrings.description,
//                       hintText: 'وصف تفصيلي للعقار',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'يرجى إدخال الوصف';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     // نوع الإعلان
//                     const Text(
//                       'نوع الإعلان',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TypeChip(
//                             label: AppStrings.forSale,
//                             isSelected:
//                                 _selectedListingType == ListingType.sale,
//                             onTap: () => setState(
//                               () => _selectedListingType = ListingType.sale,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: TypeChip(
//                             label: AppStrings.forRent,
//                             isSelected:
//                                 _selectedListingType == ListingType.rent,
//                             onTap: () => setState(
//                               () => _selectedListingType = ListingType.rent,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),

//                     // نوع العقار
//                     const Text(
//                       AppStrings.propertyType,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: PropertyType.values.map((type) {
//                         return TypeChip(
//                           label: type.arabicName,
//                           isSelected: _selectedPropertyType == type,
//                           onTap: () =>
//                               setState(() => _selectedPropertyType = type),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: 24),

//                     // السعر والمساحة
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CustomTextFormField(
//                             controller: _priceController,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.right,

//                             labelText: AppStrings.price,
//                             suffixText: AppStrings.aed,

//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'مطلوب';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: CustomTextFormField(
//                             controller: _areaController,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.right,
//                             labelText: AppStrings.area,
//                             suffixText: AppStrings.sqm,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'مطلوب';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     // الغرف والحمامات
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CustomTextFormField(
//                             controller: _bedroomsController,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.right,

//                             labelText: AppStrings.bedrooms,
//                           ),
//                         ),

//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: CustomTextFormField(
//                             controller: _bathroomsController,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.right,

//                             labelText: AppStrings.bathrooms,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),

//                     // الموقع
//                     const Text(
//                       'معلومات الموقع',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // المدينة
//                     CustomTextFormField(
//                       controller: _cityController,
//                       textAlign: TextAlign.right,

//                       labelText: 'المدينة',
//                       hintText: 'مثل: دبي',

//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'يرجى إدخال المدينة';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // المنطقة
//                     CustomTextFormField(
//                       controller: _locationController,
//                       textAlign: TextAlign.right,

//                       labelText: AppStrings.location,
//                       hintText: 'مثل: دبي مارينا',

//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'يرجى إدخال المنطقة';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),

//                     // عقار مميز
//                     SwitchListTile(
//                       title: const Text('عقار مميز'),
//                       subtitle: const Text('سيظهر في القائمة المميزة'),
//                       value: _isFeatured,
//                       onChanged: (value) => setState(() => _isFeatured = value),
//                       activeColor: AppColors.primary,
//                     ),
//                     const SizedBox(height: 24),

//                     // ملاحظة حول الصور
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.info.withValues(alpha: .1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: AppColors.info.withValues(alpha: 0.3),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             color: AppColors.info,
//                             size: 24,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               'ملاحظة: يمكنك إضافة رفع الصور لاحقاً بعد التكامل مع Firebase Storage',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: AppColors.info,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     // زر الحفظ
//                     CustomPriamryButton(
//                       onPressed: _submitForm,
//                       title: 'نشر العقار',
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // هنا يمكنك حفظ العقار في Firebase
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('تم نشر العقار بنجاح!'),
//           backgroundColor: AppColors.success,
//         ),
//       );
//       Navigator.pop(context);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/core/widgets/type_chip.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // FocusNodes
  final FocusNode _titleNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final FocusNode _priceNode = FocusNode();
  final FocusNode _areaNode = FocusNode();
  final FocusNode _bedroomsNode = FocusNode();
  final FocusNode _bathroomsNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _locationNode = FocusNode();

  PropertyType _selectedPropertyType = PropertyType.apartment;
  ListingType _selectedListingType = ListingType.sale;
  bool _isFeatured = false;

  @override
  void dispose() {
    // Controllers
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _locationController.dispose();
    _cityController.dispose();

    // FocusNodes
    _titleNode.dispose();
    _descriptionNode.dispose();
    _priceNode.dispose();
    _areaNode.dispose();
    _bedroomsNode.dispose();
    _bathroomsNode.dispose();
    _cityNode.dispose();
    _locationNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addProperty),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'المعلومات الأساسية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // عنوان العقار
                    CustomTextFormField(
                      controller: _titleController,
                      focusNode: _titleNode,
                      textAlign: TextAlign.right,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_descriptionNode),
                      labelText: 'عنوان العقار',
                      hintText: 'مثل: شقة فاخرة في دبي',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال العنوان';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // الوصف
                    CustomTextFormField(
                      controller: _descriptionController,
                      focusNode: _descriptionNode,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceNode),
                      labelText: AppStrings.description,
                      hintText: 'وصف تفصيلي للعقار',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الوصف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // نوع الإعلان
                    const Text(
                      'نوع الإعلان',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TypeChip(
                            label: AppStrings.forSale,
                            isSelected:
                                _selectedListingType == ListingType.sale,
                            onTap: () => setState(
                              () => _selectedListingType = ListingType.sale,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TypeChip(
                            label: AppStrings.forRent,
                            isSelected:
                                _selectedListingType == ListingType.rent,
                            onTap: () => setState(
                              () => _selectedListingType = ListingType.rent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // نوع العقار
                    const Text(
                      AppStrings.propertyType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PropertyType.values.map((type) {
                        return TypeChip(
                          label: type.arabicName,
                          isSelected: _selectedPropertyType == type,
                          onTap: () =>
                              setState(() => _selectedPropertyType = type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // السعر + المساحة
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: _priceController,
                            focusNode: _priceNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_areaNode),
                            labelText: AppStrings.price,
                            suffixText: AppStrings.aed,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'مطلوب';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFormField(
                            controller: _areaController,
                            focusNode: _areaNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(
                              context,
                            ).requestFocus(_bedroomsNode),
                            labelText: AppStrings.area,

                            suffixText: AppStrings.sqm,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'مطلوب';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // غرف + حمامات
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: _bedroomsController,
                            focusNode: _bedroomsNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(
                              context,
                            ).requestFocus(_bathroomsNode),
                            labelText: AppStrings.bedrooms,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFormField(
                            controller: _bathroomsController,
                            focusNode: _bathroomsNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_cityNode),
                            labelText: AppStrings.bathrooms,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // عنوان الموقع
                    const Text(
                      'معلومات الموقع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // المدينة
                    CustomTextFormField(
                      controller: _cityController,
                      focusNode: _cityNode,
                      textAlign: TextAlign.right,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_locationNode),
                      labelText: 'المدينة',
                      hintText: 'مثل: دبي',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال المدينة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // المنطقة
                    CustomTextFormField(
                      controller: _locationController,
                      focusNode: _locationNode,
                      textAlign: TextAlign.right,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      labelText: AppStrings.location,
                      hintText: 'مثل: دبي مارينا',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال المنطقة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // عقار مميز
                    SwitchListTile(
                      title: const Text('عقار مميز'),
                      subtitle: const Text('سيظهر في القائمة المميزة'),
                      value: _isFeatured,
                      onChanged: (value) => setState(() => _isFeatured = value),
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 24),

                    // ملاحظة الصور
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.info.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'ملاحظة: يمكنك إضافة رفع الصور لاحقاً بعد التكامل مع Firebase Storage',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // زر حفظ العقار
                    CustomPriamryButton(
                      onPressed: _submitForm,
                      title: 'نشر العقار',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نشر العقار بنجاح!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }
}
