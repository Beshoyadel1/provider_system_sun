import 'package:flutter/cupertino.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../features/service_settings/custom_widget/container_image_widget.dart';

class IconCarOrangeTextOfCarSparePartsInServiceSettings
    extends StatelessWidget {
  final String? imagePath, text;

  const IconCarOrangeTextOfCarSparePartsInServiceSettings(
      {super.key, this.text, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Flexible(
          child: ContainerImageWidget(
            imagePath: imagePath ?? AppImageKeys.car3_service,
            color: AppColors.orangeColor,
            width: 45,
          ),
        ),
        Expanded(
          child: TextInAppWidget(
            text: text ?? AppLanguageKeys.carSpareParts,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.orangeColor,
          ),
        )
      ],
    );
  }
}
