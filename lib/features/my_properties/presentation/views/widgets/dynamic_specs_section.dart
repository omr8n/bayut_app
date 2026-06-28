import 'package:flutter/material.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
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
    final locale = AppLocalizations.of(context)!;
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
              hintText: locale.translate(LangKeys.area),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              suffixText: locale.translate(LangKeys.areaUnit),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.translate(LangKeys.pleaseEnterArea);
                }
                if (double.tryParse(value) == null) {
                  return locale.translate(LangKeys.enterCorrectNumber);
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            // ... بقية الحقول حسب نوع العقار
            if (selectedPropertyType == PropertyType.housesAndApartments ||
                selectedPropertyType == PropertyType.underConstruction ||
                selectedPropertyType == PropertyType.villas ||
                selectedPropertyType == PropertyType.offices ||
                selectedPropertyType == PropertyType.clinics) ...[
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: roomsController,
                      hintText: locale.translate(LangKeys.rooms),
                      keyboardType: TextInputType.number,
                      textAlign: locale.isEnLocale
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormField(
                      controller: bathroomsController,
                      hintText: locale.translate(LangKeys.bathrooms),
                      keyboardType: TextInputType.number,
                      textAlign: locale.isEnLocale
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.housesAndApartments ||
                selectedPropertyType == PropertyType.offices ||
                selectedPropertyType == PropertyType.clinics ||
                selectedPropertyType == PropertyType.shops) ...[
              CustomTextFormField(
                controller: floorNumberController,
                hintText: locale.translate(LangKeys.floor),
                keyboardType: TextInputType.number,
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.buildings) ...[
              CustomTextFormField(
                controller: totalFloorsController,
                hintText: locale.translate(LangKeys.totalFloors),
                keyboardType: TextInputType.number,
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.shops ||
                selectedPropertyType == PropertyType.mallShops) ...[
              _buildDropdownField(
                locale.translate(LangKeys.location),
                selectedShopLocation,
                shopLocationTypes,
                onShopLocationChanged,
                locale,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: commercialActivityController,
                hintText: locale.translate(LangKeys.commercialActivity),
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.lands) ...[
              _buildDropdownField(
                locale.translate(LangKeys.propertyType),
                selectedLandType,
                landTypes,
                onLandTypeChanged,
                locale,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: streetWidthController,
                focusNode: streetWidthNode,
                hintText: locale.translate(LangKeys.streetWidth),
                keyboardType: TextInputType.number,
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.farms) ...[
              _buildDropdownField(
                locale.translate(LangKeys.propertyType),
                selectedFarmType,
                farmTypes,
                onFarmTypeChanged,
                locale,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                locale.translate(LangKeys.irrigationLabel),
                selectedIrrigationType,
                irrigationTypes,
                onIrrigationTypeChanged,
                locale,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: cropsController,
                hintText: locale.translate(LangKeys.crops),
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.pools) ...[
              _buildDropdownField(
                locale.translate(LangKeys.pool),
                selectedPoolType,
                poolTypes,
                onPoolTypeChanged,
                locale,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                locale.translate(LangKeys.area),
                selectedPoolSize,
                poolSizes,
                onPoolSizeChanged,
                locale,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.warehouses) ...[
              CustomTextFormField(
                controller: warehouseHeightController,
                focusNode: warehouseHeightNode,
                hintText: locale.translate(LangKeys.warehouseHeight),
                keyboardType: TextInputType.number,
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                locale.translate(LangKeys.warehouseFloorType),
                selectedWarehouseFloorType,
                warehouseFloorTypes,
                onWarehouseFloorTypeChanged,
                locale,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.halls) ...[
              CustomTextFormField(
                controller: hallCapacityController,
                focusNode: hallCapacityNode,
                hintText: locale.translate(LangKeys.hallCapacity),
                keyboardType: TextInputType.number,
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
            ],

            if (selectedPropertyType == PropertyType.workshops) ...[
              CustomTextFormField(
                controller: workshopTypeController,
                hintText: locale.translate(LangKeys.workshopType),
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: workshopHeightController,
                focusNode: workshopHeightNode,
                hintText: locale.translate(LangKeys.workshopHeight),
                keyboardType: TextInputType.number,
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
    AppLocalizations locale,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items
          .map(
            (String val) => DropdownMenuItem<String>(
              value: val,
              alignment: locale.isEnLocale
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: Text(
                locale.translate(val),
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
