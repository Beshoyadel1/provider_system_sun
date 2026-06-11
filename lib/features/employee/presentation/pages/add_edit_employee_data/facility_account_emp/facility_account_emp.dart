import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/service_permission_cubit/service_permission_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/tabs/facility_data_content_emp.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';

class FacilityAccountEmp extends StatelessWidget {
  final CreateUserRequest? employee;

  const FacilityAccountEmp({
    super.key,
    this.employee,
  });

  bool get isEdit => employee != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldColor,
          title: TextInAppWidget(
           text: isEdit ? AppLanguageKeys.editEmployee : AppLanguageKeys.createEmployee,
            textSize: 15,
            textColor: AppColors.blackColor,

          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ProviderEmployeesCubit(),
            ),
            BlocProvider(
              create: (_) => AuthCubit(),
            ),
            BlocProvider(
              create: (_) => FacilityTabCubit(),
            ),
            BlocProvider(
              create: (_) => ServicePermissionCubit(),
            ),
            BlocProvider(
              create: (_) => ServiceSettingsCubit()
                ..getChildServices(),
            ),
          ],
          child: SingleChildScrollView(
            child: FacilityDataContentEmp(
              employee: employee,
            ),
          )
        )
    );
  }
}