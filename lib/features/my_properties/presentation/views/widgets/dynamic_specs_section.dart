import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class DynamicSpecsSection extends StatelessWidget {
  final PropertyType selectedPropertyType;
  final TextEditingController roomsController;
  final TextEditingController bathroomsController;
  final TextEditingController floorNumberController;
  final TextEditingController totalFloorsController;
  final TextEditingController frontageWidthController;
  final FocusNode frontageNode;
  final TextEditingController commercialActivityController;
  final String selectedShopLocation;
  final List<String> shopLocationTypes;
  final Function(String?) onShopLocationChanged;
  final String selectedLandType;
  final List<String> landTypes;
  final Function(String?) onLandTypeChanged;
  final TextEditingController frontagesController;
  final TextEditingController streetWidthController;
  final FocusNode streetWidthNode;
  final String selectedFarmType;
  final List<String> farmTypes;
  final Function(String?) onFarmTypeChanged;
  final TextEditingController areaController;
  final FocusNode areaNode;
  final String selectedIrrigationType;
  final List<String> irrigationTypes;
  final Function(String?) onIrrigationTypeChanged;
  final TextEditingController cropsController;
  final String selectedPoolType;
  final List<String> poolTypes;
  final Function(String?) onPoolTypeChanged;
  final String selectedPoolSize;
  final List<String> poolSizes;
  final Function(String?) onPoolSizeChanged;
  final TextEditingController buildingAreaController;
  final FocusNode buildingAreaNode;
  final String selectedHeatingType;
  final List<String> heatingTypes;
  final Function(String?) onHeatingTypeChanged;
  final TextEditingController examinationRoomsController;
  final TextEditingController medicalEquipmentController;
  final TextEditingController warehouseHeightController;
  final FocusNode warehouseHeightNode;
  final String selectedWarehouseFloorType;
  final List<String> warehouseFloorTypes;
  final Function(String?) onWarehouseFloorTypeChanged;
  final TextEditingController hallCapacityController;
  final FocusNode hallCapacityNode;
  final TextEditingController workshopTypeController;
  final TextEditingController workshopHeightController;
  final FocusNode workshopHeightNode;

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
    required this.areaController,
    required this.areaNode,
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

  @override
  Widget build(BuildContext context) {
    if (selectedPropertyType == PropertyType.workshops) {
      return Column(children: [
        _buildSectionHeader('مواصفات ورشات', Icons.engineering_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(
                controller: workshopTypeController,
                textAlign: TextAlign.right,
                labelText: 'نوع الورشة',
                prefixIcon: Icons.handyman_outlined,
                hintText: 'مثل: حدادة، نجارة، ميكانيك، إلخ',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: workshopHeightController,
                focusNode: workshopHeightNode,
                textAlign: TextAlign.right,
                labelText: 'الارتفاع',
                prefixIcon: Icons.height_outlined,
                keyboardType: TextInputType.number,
                suffixText: workshopHeightNode.hasFocus || workshopHeightController.text.isNotEmpty ? 'متر' : null,
              ),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.offices) {
      return Column(children: [
        _buildSectionHeader('مواصفات مكاتب', Icons.work_outline, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(controller: roomsController, textAlign: TextAlign.right, labelText: 'عدد الغرف', prefixIcon: Icons.door_front_door_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextFormField(controller: floorNumberController, textAlign: TextAlign.right, labelText: 'رقم الطابق', prefixIcon: Icons.layers_outlined, keyboardType: TextInputType.number),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.halls) {
      return Column(children: [
        _buildSectionHeader('مواصفات صالات', Icons.meeting_room_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(
                controller: hallCapacityController,
                focusNode: hallCapacityNode,
                textAlign: TextAlign.right,
                labelText: 'السعة',
                prefixIcon: Icons.people_outline,
                keyboardType: TextInputType.number,
                suffixText: hallCapacityNode.hasFocus || hallCapacityController.text.isNotEmpty ? 'شخص' : null,
              ),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.warehouses) {
      return Column(children: [
        _buildSectionHeader('مواصفات مستودعات', Icons.warehouse_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(
                controller: warehouseHeightController,
                focusNode: warehouseHeightNode,
                textAlign: TextAlign.right,
                labelText: 'الارتفاع',
                prefixIcon: Icons.height_outlined,
                keyboardType: TextInputType.number,
                suffixText: warehouseHeightNode.hasFocus || warehouseHeightController.text.isNotEmpty ? 'متر' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdownField('نوع الأرضية', Icons.layers_outlined, selectedWarehouseFloorType, warehouseFloorTypes, onWarehouseFloorTypeChanged),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.clinics) {
      return Column(children: [
        _buildSectionHeader('مواصفات عيادات', Icons.medical_services_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(controller: examinationRoomsController, textAlign: TextAlign.right, labelText: 'عدد غرف الكشف', prefixIcon: Icons.medical_information_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextFormField(controller: floorNumberController, textAlign: TextAlign.right, labelText: 'رقم الطابق', prefixIcon: Icons.layers_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextFormField(controller: medicalEquipmentController, textAlign: TextAlign.right, labelText: 'التجهيزات الطبية المتوفرة', prefixIcon: Icons.medication_liquid_outlined, hintText: 'اذكر الأجهزة والمعدات المتوفرة', maxLines: 3),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.pools) {
      return Column(children: [
        _buildSectionHeader('مواصفات مسابح', Icons.pool_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _buildDropdownField('نوع المسبح', Icons.pool_outlined, selectedPoolType, poolTypes, onPoolTypeChanged),
              const SizedBox(height: 16),
              _buildDropdownField('حجم المسبح', Icons.architecture_outlined, selectedPoolSize, poolSizes, onPoolSizeChanged),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.farms) {
      return Column(children: [
        _buildSectionHeader('مواصفات مزارع', Icons.agriculture_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _buildDropdownField('نوع المزرعة', Icons.agriculture_outlined, selectedFarmType, farmTypes, onFarmTypeChanged),
              const SizedBox(height: 16),
              CustomTextFormField(controller: areaController, focusNode: areaNode, textAlign: TextAlign.right, labelText: 'مساحة الأرض *', prefixIcon: Icons.terrain_outlined, keyboardType: TextInputType.number, suffixText: areaNode.hasFocus || areaController.text.isNotEmpty ? 'م²' : null),
              const SizedBox(height: 16),
              _buildDropdownField('نوع الري', Icons.waves_outlined, selectedIrrigationType, irrigationTypes, onIrrigationTypeChanged),
              const SizedBox(height: 16),
              CustomTextFormField(controller: cropsController, textAlign: TextAlign.right, labelText: 'أنواع الأشجار/المحاصيل', prefixIcon: Icons.park_outlined, hintText: 'مثل: زيتون، حمضيات، خضروات'),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.lands) {
      return Column(children: [
        _buildSectionHeader('مواصفات أراضي', Icons.terrain_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _buildDropdownField('نوع الأرض *', Icons.terrain, selectedLandType, landTypes, onLandTypeChanged),
              const SizedBox(height: 16),
              CustomTextFormField(controller: frontagesController, textAlign: TextAlign.right, labelText: 'عدد الواجهات', prefixIcon: Icons.check_box_outline_blank, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextFormField(controller: streetWidthController, focusNode: streetWidthNode, textAlign: TextAlign.right, labelText: 'عرض الشارع', prefixIcon: Icons.polyline_outlined, keyboardType: TextInputType.number, suffixText: streetWidthNode.hasFocus || streetWidthController.text.isNotEmpty ? 'متر' : null),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.shops || selectedPropertyType == PropertyType.mallShops) {
      String header = selectedPropertyType == PropertyType.shops ? 'مواصفات محلات' : 'مواصفات محلات في مراكز تجارية';
      return Column(children: [
        _buildSectionHeader(header, Icons.storefront_outlined, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(controller: frontageWidthController, focusNode: frontageNode, textAlign: TextAlign.right, labelText: 'عرض الواجهة', prefixIcon: Icons.store_outlined, keyboardType: TextInputType.number, suffixText: frontageNode.hasFocus || frontageWidthController.text.isNotEmpty ? 'م' : null),
              const SizedBox(height: 16),
              _buildDropdownField('موقع المحل', Icons.location_on_outlined, selectedShopLocation, shopLocationTypes, onShopLocationChanged),
              const SizedBox(height: 16),
              CustomTextFormField(controller: commercialActivityController, textAlign: TextAlign.right, labelText: 'النشاط التجاري المسموح', prefixIcon: Icons.business_outlined, hintText: 'مثل: تجاري، مطعم، صيدلية، إلخ', maxLines: 2),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.villas) {
      return Column(children: [
        _buildSectionHeader('مواصفات الفيلات', Icons.business, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(controller: areaController, focusNode: areaNode, textAlign: TextAlign.right, labelText: 'مساحة الأرض *', prefixIcon: Icons.terrain, keyboardType: TextInputType.number, suffixText: areaNode.hasFocus || areaController.text.isNotEmpty ? 'م²' : null),
              const SizedBox(height: 16),
              CustomTextFormField(controller: buildingAreaController, focusNode: buildingAreaNode, textAlign: TextAlign.right, labelText: 'مساحة البناء', prefixIcon: Icons.home_outlined, keyboardType: TextInputType.number, suffixText: buildingAreaNode.hasFocus || buildingAreaController.text.isNotEmpty ? 'م²' : null),
              const SizedBox(height: 16),
              CustomTextFormField(controller: totalFloorsController, textAlign: TextAlign.right, labelText: 'عدد الطوابق', prefixIcon: Icons.stairs_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextFormField(controller: roomsController, textAlign: TextAlign.right, labelText: 'عدد الغرف *', prefixIcon: Icons.bed_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextFormField(controller: bathroomsController, textAlign: TextAlign.right, labelText: 'عدد الحمامات', prefixIcon: Icons.dialpad_outlined, keyboardType: TextInputType.number),
            ]),
          ),
        )
      ]);
    } else if (selectedPropertyType == PropertyType.buildings || selectedPropertyType == PropertyType.housesAndApartments || selectedPropertyType == PropertyType.underConstruction) {
      String header = selectedPropertyType == PropertyType.buildings ? 'مواصفات مباني' : 'مواصفات المنازل والشقق';
      return Column(children: [
        _buildSectionHeader(header, Icons.business, Colors.blue),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CustomTextFormField(controller: roomsController, textAlign: TextAlign.right, labelText: 'عدد الغرف *', prefixIcon: Icons.door_front_door_outlined),
              const SizedBox(height: 16),
              CustomTextFormField(controller: bathroomsController, textAlign: TextAlign.right, labelText: 'عدد الحمامات', prefixIcon: Icons.bathtub_outlined),
              const SizedBox(height: 16),
              CustomTextFormField(controller: floorNumberController, textAlign: TextAlign.right, labelText: 'رقم الطابق', prefixIcon: Icons.layers_outlined, hintText: '0 للطابق الأرضي'),
              const SizedBox(height: 16),
              CustomTextFormField(controller: totalFloorsController, textAlign: TextAlign.right, labelText: 'عدد طوابق البناء', prefixIcon: Icons.apartment_outlined),
              const SizedBox(height: 16),
              _buildDropdownField('نوع التدفئة', Icons.fireplace_outlined, selectedHeatingType, heatingTypes, onHeatingTypeChanged),
            ]),
          ),
        )
      ]);
    }
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color))]));
  }

  Widget _buildDropdownField(String label, IconData icon, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      items: items.map((String val) => DropdownMenuItem<String>(value: val, alignment: AlignmentDirectional.centerEnd, child: Text(val, textAlign: TextAlign.right))).toList(),
      onChanged: onChanged,
    );
  }
}
