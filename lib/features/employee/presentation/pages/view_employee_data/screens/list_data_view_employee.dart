import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';

import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_state.dart';

import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/facility_account_emp.dart';

import 'package:sun_web_system/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';

import 'package:sun_web_system/features/employee/presentation/custom_widget/custom_view_all_employee_list_widget.dart';

class ListDataViewEmployee extends StatelessWidget {
  const ListDataViewEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        ProviderEmployeesCubit,
        ProviderEmployeesState>(
      builder: (context, state) {

        // =========================================================
        // LOADING
        // =========================================================

        if (state is ProviderEmployeesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // =========================================================
        // ERROR
        // =========================================================

        if (state is ProviderEmployeesError) {
          return Center(
            child: Text(state.message),
          );
        }

        // =========================================================
        // SUCCESS
        // =========================================================

        if (state is ProviderEmployeesSuccess) {

          if (state.employees.isEmpty) {
            return const TextEmptyViewData();
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: state.employees.length,

            separatorBuilder: (_, __) =>
            const SizedBox(height: 10),

            itemBuilder: (context, index) {

              final employee =
              state.employees[index];

              return CustomViewAllEmployeeListWidget(
                id: employee.userid?.toString() ?? '-',

                nameEmployee:
                employee.username ?? '-',

                phone:
                employee.phone ?? '-',

                email:
                employee.email ?? '-',

                isActive:
                employee.isActive,

                nameButton:
                AppLanguageKeys.details,

                onTapDetails: () async {

                  final result = await Navigator.push(
                    context,
                    NavigateToPageWidget(
                      FacilityAccountEmp(
                        employee: employee,
                      ),
                    ),
                  );

                  if (result == true &&
                      context.mounted) {

                    await context
                        .read<ProviderEmployeesCubit>()
                        .getEmployees();
                  }
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}