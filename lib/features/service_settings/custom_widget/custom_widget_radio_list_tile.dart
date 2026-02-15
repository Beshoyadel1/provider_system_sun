import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';

class CustomWidgetRadioListTile extends StatelessWidget {
  final String text;
  final int value;

  const CustomWidgetRadioListTile({
    super.key,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsContainerSettingCubit,
            DetailsContainerSettingState>(
        buildWhen: (previous, current) =>
            previous.selectedOption != current.selectedOption,
        builder: (context, state) {
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
              groupValue: state.selectedOption,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                context
                    .read<DetailsContainerSettingCubit>()
                    .selectOption(value!);
              },
            ),
          );
        });
  }
}
