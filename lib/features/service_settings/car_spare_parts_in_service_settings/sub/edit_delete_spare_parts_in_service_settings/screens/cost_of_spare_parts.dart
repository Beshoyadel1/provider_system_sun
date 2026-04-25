import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/row_text_icon_orange.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';
import '../../../../../../../../features/internal_services/internal_orders/custom_widget/row_number_coin_widget.dart';
import '../../../../../../../../core/theming/assets.dart';

class CostOfSpareParts extends StatelessWidget {
  final String cost;

  const CostOfSpareParts({
    super.key,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLanguageKeys.cost,
      child: RowTextIconOrange(text: cost, imagePath: AppImageKeys.coin,textSize: 15,textColor: AppColors.orangeColor,),
    );
  }
}