import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import '../cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';
import 'dashboard_widgets.dart';
import 'data_account_balance.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance(
      {super.key, this.height = 262, this.onDetails, this.onRetry});
  final double height;
  final VoidCallback? onDetails;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => DashboardPanel(
      height: height,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(
              child: DashboardTitle(AppLanguageKeys.accountBalanceKey,
                  subtitle: AppLanguageKeys.dashboardAllTimePerformance)),
          if (onDetails != null)
            FilledButton(
                onPressed: onDetails,
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(66, 29),
                    padding: const EdgeInsets.symmetric(horizontal: 12)),
                child: Text(dashboardLabel(context, AppLanguageKeys.detailsKey),
                    style: const TextStyle(fontSize: 10))),
        ]),
        const SizedBox(height: 8),
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
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${dashboardMoney(state.data.totalBalance)} ${dashboardLabel(context, AppLanguageKeys.sar)}',
                    style: const TextStyle(
                        color: AppColors.orangeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Expanded(
                    child: state.data.accountsBalance.isEmpty
                        ? const DashboardFeedback(
                            message: AppLanguageKeys.dashboardNoBalanceDetails)
                        : ListView.separated(
                            primary: false,
                            padding: EdgeInsets.zero,
                            itemCount: state.data.accountsBalance.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 7),
                            itemBuilder: (_, index) => DataAccountBalance(
                                item: state.data.accountsBalance[index]))),
              ]);
        })),
      ]));
}
