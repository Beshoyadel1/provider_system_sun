import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/mobile_of_data_container_in_list_data_first_screen_permissions.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/web_of_data_container_in_list_data_first_screen_permissions.dart';


class DataNameWithTextFieldAndUploadImagePermissions extends StatelessWidget {
  const DataNameWithTextFieldAndUploadImagePermissions({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    return isMobile
        ? MobileOfDataContainerInListDataFirstScreenPermissions()
        : WebOfDataContainerInListDataFirstScreenPermissions();
  }
}
