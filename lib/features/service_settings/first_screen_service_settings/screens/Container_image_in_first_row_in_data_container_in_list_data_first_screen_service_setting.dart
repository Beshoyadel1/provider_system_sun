import 'package:flutter/cupertino.dart';
import '../../../../../../features/service_settings/custom_widget/container_image_widget.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';

class ContainerImageInFirstRowInDataContainerInListDataFirstScreenServiceSetting
    extends StatelessWidget {
  const ContainerImageInFirstRowInDataContainerInListDataFirstScreenServiceSetting(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: ContainerImageWidget(
        imagePath: AppImageKeys.logo10,
        color: AppColors.whiteColor,
        height: 65,
        width: 65,
      ),
    );
  }
}
