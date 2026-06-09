import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/mobile_as_part_user_select_permissions.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/web_as_part_user_select_permissions.dart';

class PartUserSelectPermissions extends StatelessWidget {
  const PartUserSelectPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth + 200;
    return isMobile
        ? const MobileAsPartUserSelectPermissions()
        : const WebAsPartUserSelectPermissions();
  }
}
