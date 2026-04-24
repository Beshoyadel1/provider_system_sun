import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/list_data_add_spare_parts_in_service_settings.dart';
import '../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../core/theming/colors.dart';

class AddSparePartsInServiceSettings extends StatelessWidget {
  const AddSparePartsInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ListDataAddSparePartsInServiceSettings(),
          ),
        ),
      ),
    );
  }
}