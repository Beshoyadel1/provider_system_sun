import 'package:flutter/cupertino.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../custom_widget/container_with_image_container_and_two_text_widget.dart';
import '../../../../../../../core/theming/assets.dart';


class FirstRowWithTwoContainerImageAndTwoText extends StatelessWidget {
  const FirstRowWithTwoContainerImageAndTwoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        ContainerWithImageContainerAndTwoTextWidget(
            imagePath: AppImageKeys.service33,
            title: AppLanguageKeys.maintenanceAndRepair,
            subTitle: '0 طلب'
        ),
        ContainerWithImageContainerAndTwoTextWidget(
            imagePath: AppImageKeys.service33,
            title: AppLanguageKeys.maintenanceAndRepair,
            subTitle: '0 طلب'
        ),
      ],
    );
  }
}