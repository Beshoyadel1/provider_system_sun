
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../features/service_settings/presentation/custom_widget/container_image_widget.dart';

class IconCarOrangeTextOfAddedMaintenanceAndInternalServices
    extends StatelessWidget {
  final String text;
   final Uint8List? imageMemory;
  const IconCarOrangeTextOfAddedMaintenanceAndInternalServices({super.key,required this.text, this.imageMemory});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
         Flexible(
          child: ContainerImageWidget(
            imageMemory: imageMemory,
            color: AppColors.orangeColor,
            width: 45,
          ),
        ),
        Expanded(
          child: TextInAppWidget(
            text:text?? AppLanguageKeys.addInternalServices,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.orangeColor,
          ),
        )
      ],
    );
  }
}
