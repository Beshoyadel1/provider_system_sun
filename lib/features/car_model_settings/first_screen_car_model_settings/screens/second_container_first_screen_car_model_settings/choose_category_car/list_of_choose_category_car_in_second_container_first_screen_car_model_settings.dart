import 'package:flutter/cupertino.dart';
import 'mobile_of_list_of_choose_category_car_in_second_container_first_screen_car_model_settings.dart';
import 'tab_of_list_of_choose_category_car_in_second_container_first_screen_car_model_settings.dart';
import 'web_of_list_of_choose_category_car_in_second_container_first_screen_car_model_settings.dart';

class ListOfChooseCategoryCarInSecondContainerFirstScreenCarModelSettings
    extends StatelessWidget {
  const ListOfChooseCategoryCarInSecondContainerFirstScreenCarModelSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTable = size.width > 500 && size.width <= 1125;
    bool isWeb = size.width > 1125;

    return isWeb
        ? WebOfListOfChooseCategoryCarInSecondContainerFirstScreenCarModelSettings()
        : isTable
            ? TabOfListOfChooseCategoryCarInSecondContainerFirstScreenCarModelSettings()
            : MobileOfListOfChooseCategoryCarInSecondContainerFirstScreenCarModelSettings();
  }
}
