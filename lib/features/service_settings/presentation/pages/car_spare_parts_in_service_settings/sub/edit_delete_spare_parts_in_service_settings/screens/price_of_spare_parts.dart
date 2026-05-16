import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/internal_services/presentation/pages/internal_orders/custom_widget/row_text_icon_orange.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';
import '../../../../../../../../core/theming/assets.dart';

class PriceOfSpareParts extends StatelessWidget {
  final String price;

  const PriceOfSpareParts({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLanguageKeys.price,
      child: RowTextIconOrange(text: price, imagePath: AppImageKeys.coin,textSize: 15,textColor: AppColors.orangeColor,),
    );
  }
}