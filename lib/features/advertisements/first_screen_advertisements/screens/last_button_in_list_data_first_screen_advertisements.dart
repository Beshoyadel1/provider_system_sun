import 'package:flutter/cupertino.dart';
import '../../../../../../core/pages_widgets/button_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';

class LastButtonInListDataFirstScreenAdvertisements extends StatelessWidget {
  final void Function()? onTap;
  final String? text;

  const LastButtonInListDataFirstScreenAdvertisements(
      {super.key, this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      text: text ?? AppLanguageKeys.createBannerAd,
      textColor: AppColors.whiteColor,
      buttonColor: AppColors.orangeColor,
      textSize: 12,
      fontWeightIndex: FontSelectionData.regularFontFamily,
      heightContainer: 40,
      widthContainer: 150,
      borderRadius: 30,
      onTap: onTap,
    );
  }
}
