import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/add_property_body.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/add_property_view_body_bloc_builder.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key, this.propertyEntity});
  final PropertyEntity? propertyEntity;

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.propertyEntity != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // التعديل الجوهري: نطلب الـ Cubit الجاهز من الـ Service Locator
      create: (context) => getIt.get<AddPropertyCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        appBar: AppBar(
          title: Text(isEdit ? 'تعديل العقار' : 'إضافة عقار جديد'),
          centerTitle: true,
        ),
        body: AddPropertyViewBodyBlocBuilder(
          child: AddPropertyBody(
            isEdit: isEdit,
            propertyEntity: widget.propertyEntity,
          ),
        ),
      ),
    );
  }
}
