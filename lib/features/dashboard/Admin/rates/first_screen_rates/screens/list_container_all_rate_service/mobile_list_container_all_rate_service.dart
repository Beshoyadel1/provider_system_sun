import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../features/dashboard/Admin/rates/custom_widget/Container_list_container_all_rate_service_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../features/dashboard/Admin/rates/first_screen_rates/screens/list_container_all_rate_service/first_container_in_list_container_all_rate_service.dart';

class MobileListContainerAllRateService extends StatelessWidget {
  const MobileListContainerAllRateService({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            FirstContainerInListContainerAllRateService(),
            ContainerListContainerAllRateServiceWidget(
                imagePath: AppImageKeys.service33,
                title: AppLanguageKeys.internalServices,
                subTitle: AppLanguageKeys.maintenanceAndRepair
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            ContainerListContainerAllRateServiceWidget(
                imagePath: AppImageKeys.service44,
                title: AppLanguageKeys.internalServices,
                subTitle: AppLanguageKeys.oils
            ),
            ContainerListContainerAllRateServiceWidget(
                imagePath: AppImageKeys.service99,
                title: AppLanguageKeys.spareParts,
                subTitle: AppLanguageKeys.allChanges
            )
          ],
        ),
      ],
    );
  }
}

