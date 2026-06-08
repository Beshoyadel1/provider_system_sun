import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/employee/presentation/pages/edit_employee_data/facility_account_emp/sub/tabs_widget_emp.dart';
import '../../../../../../features/store_page/data/model/facility_model/facility_model.dart';
import '../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import '../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../core/language/language_constant.dart';

class FacilityAccountEmp extends StatelessWidget {
  final EmployeeModel employee;

  const FacilityAccountEmp({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => FacilityTabCubit(),
        child: BlocBuilder<FacilityTabCubit, FacilityTabState>(
          buildWhen: (previous, current) => current is ChangeIndexState,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomContainer(
                      containerWidth: double.infinity,
                      isSelected: false,
                      border: const Border(
                        top: BorderSide(color: AppColors.lightGreyColor),
                        left: BorderSide(color: AppColors.lightGreyColor),
                        right: BorderSide(color: AppColors.lightGreyColor),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      typeWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextInAppWidget(
                            text: AppLanguageKeys.continueFacilityDataKey,
                            textSize: 22,
                            fontWeightIndex: FontSelectionData.mediumFontFamily,
                          ),
                          const SizedBox(height: 10),
                          TabsWidgetEmp(
                            tabs: facilityTabsEmployee(employee),
                          ),
                          const SizedBox(height: 30),
                          facilityTabsEmployee(employee)[
                          context.read<FacilityTabCubit>().selectedIndex
                          ].content,
                          const SizedBox(height: 100),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
