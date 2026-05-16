import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class CustomWidgetRadioListTile extends StatelessWidget {
  final String text;
  final int value;
  final int brandId;

  const CustomWidgetRadioListTile({
    super.key,
    required this.text,
    required this.value,
    required this.brandId,
  });

  @override
  Widget build(BuildContext context) {
    final selected = context
        .watch<CreateProvServiceCubit>()
        .brandSelection[brandId];

    return Expanded(
      child: RadioListTile<int>(
        activeColor: AppColors.orangeColor,
        title: TextInAppWidget(
          text: text,
          textSize: 13,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.darkColor,
        ),
        value: value,
        groupValue: selected, // ✅ هنا الحل
        contentPadding: EdgeInsets.zero,
        onChanged: (val) {
          context.read<CreateProvServiceCubit>().setBrandSelection(
            brandId: brandId,
            option: val!,
          );
        },
      ),
    );
  }
}