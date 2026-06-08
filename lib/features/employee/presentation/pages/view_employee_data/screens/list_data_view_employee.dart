import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/accounts_management/presentation/custom_widget/title_with_sub_title.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/employee_cubit/employee_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/employee_cubit/employee_state.dart';
import 'package:sun_web_system/features/employee/presentation/pages/edit_employee_data/facility_account_emp/facility_account_emp.dart';
import 'package:sun_web_system/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';

class ListDataViewEmployee extends StatelessWidget {
  const ListDataViewEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is EmployeeError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is EmployeeSuccess) {
          if (state.employees.isEmpty) {
            return const TextEmptyViewData();
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.employees.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final employee = state.employees[index];

              return CustomContainer(
                isSelected: false,
                onTap: () {
                  print("Employee Clicked: ${employee.userId}");
                  Navigator.push(
                    context,
                    NavigateToPageWidget(
                      FacilityAccountEmp(
                        employee: employee,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                containerWidth: double.infinity,
                typeWidget: Wrap(
                  spacing: 35,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    TitleWithSubTitle(
                      title: AppLanguageKeys.identity,
                      subTitle: employee.userId.toString(),
                      titleColor: AppColors.greyColor,
                      textSizeTitle: 15,
                      textSizeSubTitle: 14,
                    ),
                    TitleWithSubTitle(
                      title: AppLanguageKeys.name,
                      subTitle: employee.userName,
                      titleColor: AppColors.greyColor,
                      textSizeTitle: 15,
                      textSizeSubTitle: 14,
                    ),
                    TitleWithSubTitle(
                      title: AppLanguageKeys.phoneNumber,
                      subTitle: employee.phone,
                      titleColor: AppColors.greyColor,
                      textSizeTitle: 15,
                      textSizeSubTitle: 14,
                    ),
                    TitleWithSubTitle(
                      title: AppLanguageKeys.email,
                      subTitle: employee.email,
                      titleColor: AppColors.greyColor,
                      textSizeTitle: 15,
                      textSizeSubTitle: 14,
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
