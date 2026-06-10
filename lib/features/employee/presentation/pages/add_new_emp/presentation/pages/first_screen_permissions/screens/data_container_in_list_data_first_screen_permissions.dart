import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/service_permission_cubit/service_permission_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/data_name_with_text_field_and_upload_image_permissions.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/part_user_select_permissions.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/permissions_and_services_provided_to_the_user_text.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/select_permissions_and_services_provided_to_the_user_with_image.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/title_with_sub_title_add_new_user.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/user_permissions_settings_text_container.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';

class DataContainerInListDataFirstScreenPermissions extends StatelessWidget {
  const DataContainerInListDataFirstScreenPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TitleWithSubTitleAddNewUser(),
          const DataNameWithTextFieldAndUploadImagePermissions(),
          // UserPermissionsSettingsTextContainer(),
          // PartUserSelectPermissions(),
          const PermissionsAndServicesProvidedToTheUserText(),
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => ServicePermissionCubit(),
              ),
              BlocProvider(
                create: (_) => ServiceSettingsCubit()
                  ..getChildServices(),
              ),
            ],
            child: const SelectPermissionsAndServicesProvidedToTheUserWithImage(),
          )

        ],
      ),
    );
  }
}
