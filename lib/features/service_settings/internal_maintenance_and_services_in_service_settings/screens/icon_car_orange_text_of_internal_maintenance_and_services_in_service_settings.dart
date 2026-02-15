import 'package:flutter/cupertino.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../features/service_settings/custom_widget/container_image_widget.dart';

class IconCarOrangeTextOfInternalMaintenanceAndServicesInServiceSettings
    extends StatelessWidget {
  const IconCarOrangeTextOfInternalMaintenanceAndServicesInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 5,
      children: [
        Flexible(
          child: ContainerImageWidget(
            imagePath: AppImageKeys.car2_service,
            color: AppColors.orangeColor,
            width: 45,
          ),
        ),
        Expanded(
          child: TextInAppWidget(
            text: AppLanguageKeys.mobileAndTransportServices,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.orangeColor,
          ),
        )
      ],
    );
  }
}
