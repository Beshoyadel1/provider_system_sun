import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/sub/facility_data_content_emp.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/work_time_cubit/work_time_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/facility_account/tabs/bank_account_content.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/facility_account/tabs/branches_content.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/facility_account/tabs/facility_data_content.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/facility_account/tabs/working_hours_content.dart';
import '../../../../../../core/language/language_constant.dart';

class FacilityModel {
  final String title;
  final Widget content;

  FacilityModel({required this.title, required this.content});
}

final List<FacilityModel> facilityTabs = [
  FacilityModel(
    title: AppLanguageKeys.facilityDataKey,
    content: const FacilityDataContent(),
  ),

  FacilityModel(
    title: AppLanguageKeys.branchesKey,
    content: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BranchCubit()..getProviderBranches()),
      ],
      child: const BranchesContent(),
    ),
  ),
  FacilityModel(
    title: AppLanguageKeys.workingHoursKey,
    content: BlocProvider(
        create: (context) => UpdateWorkTimeCubit(),
        child: const WorkingHoursContent(),
      ),
    ),

  FacilityModel(
      title: AppLanguageKeys.bankAccountKey,
      content: const BankAccountContent()),
];
final List<FacilityModel> facilityTabsCompleteData = [

  FacilityModel(
    title: AppLanguageKeys.facilityDataKey,
    content: const FacilityDataContent(),
  ),

  FacilityModel(
    title: AppLanguageKeys.branchesKey,
    content: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BranchCubit()..getProviderBranches()),
      ],
      child: const BranchesContent(),
    ),
  ),
  FacilityModel(
    title: AppLanguageKeys.workingHoursKey,
    content: BlocProvider(
      create: (context) => UpdateWorkTimeCubit(),
      child: const WorkingHoursContent(),
    ),
  ),

  FacilityModel(
      title: AppLanguageKeys.bankAccountKey,
      content: const BankAccountContent()
  ),
];

List<FacilityModel> facilityTabsEmployee(
    EmployeeModel employee,
    ) {
  return [
    // FacilityModel(
    //   title: AppLanguageKeys.facilityDataKey,
    //   content: BlocProvider(
    //     create: (_) => EmployeeCubit(),
    //     child: FacilityDataContentEmp(
    //       employee: employee,
    //     ),
    //   ),
    // ),

    // FacilityModel(
    //   title: AppLanguageKeys.branchesKey,
    //   content: BranchesContentEmp(
    //     employee: employee,
    //   ),
    // ),
    //
    // FacilityModel(
    //   title: AppLanguageKeys.workingHoursKey,
    //   content: WorkingHoursContentEmp(
    //     employee: employee,
    //   ),
    // ),

  ];
}