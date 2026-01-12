import 'package:flutter/cupertino.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/data_is_mobile_in_first_row_in_data_container_in_list_data_first_screen_service_setting.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/data_is_not_mobile_in_first_row_in_data_container_in_list_data_first_screen_service_setting.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';

class FirstRowInDataContainerInListDataFirstScreenServiceSetting
    extends StatelessWidget {
  final String? text1, text2, textContainer;
  final Function()? onTap;

  const FirstRowInDataContainerInListDataFirstScreenServiceSetting({
    super.key,
    this.text1,
    this.text2,
    this.textContainer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    return isMobile
        ? DataIsMobileInFirstRowInDataContainerInListDataFirstScreenServiceSetting(
            text1: text1,
            text2: text2,
            onTap: onTap,
            textContainer: textContainer,
          )
        : DataIsNotMobileInFirstRowInDataContainerInListDataFirstScreenServiceSetting(
            text1: text1,
            text2: text2,
            onTap: onTap,
            textContainer: textContainer,
          );
  }
}
