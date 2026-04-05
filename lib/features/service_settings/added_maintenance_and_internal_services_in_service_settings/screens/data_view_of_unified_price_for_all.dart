import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/container_return_to_page_setting.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';

class DataViewOfUnifiedPriceForAll extends StatefulWidget {
  final int index;

  const DataViewOfUnifiedPriceForAll({
    super.key,
    required this.index,
  });

  @override
  State<DataViewOfUnifiedPriceForAll> createState() =>
      _DataViewOfUnifiedPriceForAllState();
}

class _DataViewOfUnifiedPriceForAllState
    extends State<DataViewOfUnifiedPriceForAll> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormFieldWidget(
        textFormController: controller,
        fillColor: AppColors.transparent,
        borderColor: AppColors.darkColor.withOpacity(0.2),
        hintText: AppLanguageKeys.sar,
        hintTextSize: 12,
        hintTextColor: AppColors.orangeColor,
        textSize: 15,
        textFormWidth: 400,
        isDigit: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}