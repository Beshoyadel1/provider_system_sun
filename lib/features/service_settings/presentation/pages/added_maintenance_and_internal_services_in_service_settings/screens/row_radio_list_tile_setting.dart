import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../../features/service_settings/presentation/custom_widget/custom_widget_radio_list_tile.dart';
import '../../../../../../core/language/language_constant.dart';

class RowRadioListTileSetting extends StatelessWidget {
  final int brandId;

  const RowRadioListTileSetting({
    super.key,
    required this.brandId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomWidgetRadioListTile(
          text: AppLanguageKeys.unifiedPriceForAll,
          value: 0,
          brandId: brandId,
        ),
        CustomWidgetRadioListTile(
          text: AppLanguageKeys.pricePerCategory,
          value: 1,
          brandId: brandId,
        ),
        InkWell(
          onTap: (){
            context.read<CreateProvServiceCubit>().setBrandSelection(
              brandId: brandId,
              option: -1,
            );
          },
          child: const TextInAppWidget(
            text: AppLanguageKeys.restAll,
            textSize: 13,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: AppColors.darkColor,
          ),
        ),
      ],
    );
  }
}