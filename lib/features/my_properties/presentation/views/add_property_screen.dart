import 'package:flutter/material.dart';

import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'package:test_graduation/features/my_properties/presentation/views/widgets/add_property_body.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/add_property_view_body_bloc_builder.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

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
    final locale = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isEdit
              ? locale!.translate(LangKeys.editProperty)
              : locale!.translate(LangKeys.addNewProperty),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: AddPropertyViewBodyBlocBuilder(
        child: AddPropertyBody(
          isEdit: isEdit,
          propertyEntity: widget.propertyEntity,
        ),
      ),
    );
  }
}
