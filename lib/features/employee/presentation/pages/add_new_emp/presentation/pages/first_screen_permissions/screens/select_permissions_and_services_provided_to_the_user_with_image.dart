import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/custom_widget/check_box_with_text_widget.dart';

class SelectPermissionsAndServicesProvidedToTheUserWithImage
    extends StatelessWidget {
  const SelectPermissionsAndServicesProvidedToTheUserWithImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            CheckBoxWithText(
              text: AppLanguageKeys.maintenanceServices,
              imageSelect: AppImageKeys.service33,
            ),
            CheckBoxWithText(
              text: AppLanguageKeys.maintenanceServices,
              imageSelect: AppImageKeys.service44,
            )
          ],
        )
      ],
    );
  }
}
