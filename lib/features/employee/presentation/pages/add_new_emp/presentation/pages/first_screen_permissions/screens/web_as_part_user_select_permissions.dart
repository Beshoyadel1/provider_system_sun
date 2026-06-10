import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';

import '../../../custom_widget/check_box_with_text_widget.dart';

class WebAsPartUserSelectPermissions extends StatelessWidget {
  const WebAsPartUserSelectPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CheckBoxWithText(text: AppLanguageKeys.statistics,serviceId: 5,),
        CheckBoxWithText(text: AppLanguageKeys.servicesSettings,serviceId: 5,),
        CheckBoxWithText(text: AppLanguageKeys.carModelSettings,serviceId: 5,),
        CheckBoxWithText(text: AppLanguageKeys.accountManagement,serviceId: 5,),
        CheckBoxWithText(text: AppLanguageKeys.permissionsManagement,serviceId: 5,),
        CheckBoxWithText(text: AppLanguageKeys.organizationManagement,serviceId: 5,),
      ],
    );
  }
}
