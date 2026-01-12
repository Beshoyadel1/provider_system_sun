import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/container_return_to_page_setting.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/list_mobile_of_data_view_of_price_per_category.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/list_web_of_data_view_of_price_per_category.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';

class DataViewOfPricePerCategory extends StatelessWidget {
  const DataViewOfPricePerCategory({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        spacing: 10,
        children: [
          isMobile ?
          ListMobileOfDataViewOfPricePerCategory()
              :
          ListWebOfDataViewOfPricePerCategory(),

          Row(
            children: [
              SizedBox(
                width: 150,
                child: ContainerReturnToPageSetting(
                  color: AppColors.orangeColor,
                  text: AppLanguageKeys.add,
                  icon: CupertinoIcons.add,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
