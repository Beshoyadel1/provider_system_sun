import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';

import '../../../custom_widget/check_box_with_text_widget.dart';

class WebAsPartUserSelectPermissions extends StatelessWidget {
  const WebAsPartUserSelectPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CheckBoxWithText(text: AppLanguageKeys.statistics),
        CheckBoxWithText(text: AppLanguageKeys.servicesSettings),
        CheckBoxWithText(text: AppLanguageKeys.carModelSettings),
        CheckBoxWithText(text: AppLanguageKeys.accountManagement),
        CheckBoxWithText(text: AppLanguageKeys.permissionsManagement),
        CheckBoxWithText(text: AppLanguageKeys.organizationManagement),
      ],
    );
  }
}
