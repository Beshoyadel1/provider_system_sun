import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import '../cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import '../cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';
import 'dashboard_widgets.dart';
import 'employe_widget.dart';

class EmployeesPerformance extends StatelessWidget {
  const EmployeesPerformance({super.key, this.height = 396, this.onRetry});
  final double height;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => DashboardPanel(
      height: height,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const DashboardTitle(AppLanguageKeys.topEmployeesKey,
            subtitle: AppLanguageKeys.topOrderReceiversKey),
        const SizedBox(height: 14),
        Expanded(child: BlocBuilder<
                GetProviderTotalRateAndEmployeeAndBalanceCubit,
                GetProviderTotalRateAndEmployeeAndBalanceState>(
            builder: (context, state) {
          if (state is GetProviderTotalRateAndEmployeeAndBalanceError) {
            return DashboardFeedback(failed: true, onRetry: onRetry);
          }
          if (state is! GetProviderTotalRateAndEmployeeAndBalanceSuccess) {
            return const DashboardFeedback(loading: true);
          }
          final employees = state.data.topEmployees;
          if (employees.isEmpty) return const DashboardFeedback();
          return ListView.separated(
              primary: false,
              padding: EdgeInsets.zero,
              itemCount: employees.length,
              separatorBuilder: (_, __) => const SizedBox(height: 9),
              itemBuilder: (_, index) =>
                  EmployeWidget(employee: employees[index]));
        })),
      ]));
}
