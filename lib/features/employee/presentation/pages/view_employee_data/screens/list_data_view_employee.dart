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
                typeWidget: LayoutBuilder(
                  builder: (context, constraints) {
                    final double itemWidth;

                    if (constraints.maxWidth >= 700) {
                      itemWidth = (constraints.maxWidth - 90) / 4;
                    } else if (constraints.maxWidth >= 300) {
                      itemWidth = (constraints.maxWidth - 20) / 2;
                    } else {
                      itemWidth = constraints.maxWidth;
                    }

                    Widget buildItem({
                      required String title,
                      required String value,
                    }) {
                      return SizedBox(
                        width: itemWidth,
                        child: TitleWithSubTitle(
                          title: title,
                          subTitle: value,
                          titleColor: AppColors.greyColor,
                          textSizeTitle: 15,
                          textSizeSubTitle: 14,
                        ),
                      );
                    }

                    return Wrap(
                      spacing: 20,
                      runSpacing: 15,
                      children: [
                        buildItem(
                          title: AppLanguageKeys.identity,
                          value: employee.userId.toString(),
                        ),
                        buildItem(
                          title: AppLanguageKeys.name,
                          value: employee.userName,
                        ),
                        buildItem(
                          title: AppLanguageKeys.phoneNumber,
                          value: employee.phone,
                        ),
                        buildItem(
                          title: AppLanguageKeys.email,
                          value: employee.email,
                        ),
                      ],
                    );
                  },
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
