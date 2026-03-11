import 'package:flutter/material.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class DynamicSpecsSection extends StatelessWidget {
  const DynamicSpecsSection({
    super.key,
    required this.selectedPropertyType,
    required this.roomsController,
    required this.bathroomsController,
    required this.floorNumberController,
    required this.totalFloorsController,
    required this.frontageWidthController,
    required this.frontageNode,
    required this.commercialActivityController,
    required this.selectedShopLocation,
    required this.shopLocationTypes,
    required this.onShopLocationChanged,
    required this.selectedLandType,
    required this.landTypes,
    required this.onLandTypeChanged,
    required this.frontagesController,
    required this.streetWidthController,
    required this.streetWidthNode,
    required this.selectedFarmType,
    required this.farmTypes,
    required this.onFarmTypeChanged,
    required this.areaController, // 🔥 تم إرجاع حقل المساحة
    required this.areaNode, // 🔥 تم إرجاع حقل المساحة
    required this.selectedIrrigationType,
    required this.irrigationTypes,
    required this.onIrrigationTypeChanged,
    required this.cropsController,
    required this.selectedPoolType,
    required this.poolTypes,
    required this.onPoolTypeChanged,
    required this.selectedPoolSize,
    required this.poolSizes,
    required this.onPoolSizeChanged,
    required this.buildingAreaController,
    required this.buildingAreaNode,
    required this.selectedHeatingType,
    required this.heatingTypes,
    required this.onHeatingTypeChanged,
    required this.examinationRoomsController,
    required this.medicalEquipmentController,
    required this.warehouseHeightController,
    required this.warehouseHeightNode,
    required this.selectedWarehouseFloorType,
    required this.warehouseFloorTypes,
    required this.onWarehouseFloorTypeChanged,
    required this.hallCapacityController,
    required this.hallCapacityNode,
    required this.workshopTypeController,
    required this.workshopHeightController,
    required this.workshopHeightNode,
  });

  final PropertyType selectedPropertyType;
  final TextEditingController roomsController,
      bathroomsController,
      floorNumberController,
      totalFloorsController,
      frontageWidthController,
      commercialActivityController,
      frontagesController,
      streetWidthController,
      cropsController,
      areaController,
      buildingAreaController,
      examinationRoomsController,
      medicalEquipmentController,
      warehouseHeightController,
      hallCapacityController,
      workshopTypeController,
      workshopHeightController;
  final FocusNode frontageNode,
      streetWidthNode,
      areaNode,
      buildingAreaNode,
      warehouseHeightNode,
      hallCapacityNode,
      workshopHeightNode;
  final String selectedShopLocation,
      selectedLandType,
      selectedFarmType,
      selectedIrrigationType,
      selectedPoolType,
      selectedPoolSize,
      selectedHeatingType,
      selectedWarehouseFloorType;
  final List<String> shopLocationTypes,
      landTypes,
      farmTypes,
      irrigationTypes,
      poolTypes,
      poolSizes,
      heatingTypes,
      warehouseFloorTypes;
  final ValueChanged<String?> onShopLocationChanged,
      onLandTypeChanged,
      onFarmTypeChanged,
      onIrrigationTypeChanged,
      onPoolTypeChanged,
      onPoolSizeChanged,
      onHeatingTypeChanged,
      onWarehouseFloorTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔥 إعادة عرض حقل المساحة كأول عنصر لأنه مشترك بين الجميع
            CustomTextFormField(
              controller: areaController,
              focusNode: areaNode,
              hintText: 'المساحة',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.right,
              suffixText: 'م²',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال المساحة';
                }
                if (double.tryParse(value) == null) {
                  return 'أدخل رقم صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            // ... بقية الحقول حسب نوع العقار
          ],
        ),
      ),
    );
  }
}
