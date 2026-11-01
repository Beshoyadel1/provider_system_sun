import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import '../cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';
import 'dashboard_widgets.dart';

class ServicesEvaluation extends StatelessWidget {
  const ServicesEvaluation({super.key});
  @override
  Widget build(BuildContext context) => DashboardPanel(
      height: 110,
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              const DashboardTitle(AppLanguageKeys.servicesRatingKey),
              const SizedBox(height: 8),
              BlocBuilder<GetProviderTotalRateAndEmployeeAndBalanceCubit,
                      GetProviderTotalRateAndEmployeeAndBalanceState>(
                  builder: (context, state) {
                final rate =
                    state is GetProviderTotalRateAndEmployeeAndBalanceSuccess
                        ? state.data.averageRate
                        : null;
                return Row(children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.orangeColor, size: 29),
                  const SizedBox(width: 6),
                  if (state is GetProviderTotalRateAndEmployeeAndBalanceLoading)
                    const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2))
                  else
                    Text(
                        rate == null || rate < 0 || rate > 5
                            ? '—'
                            : rate.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 7),
                  Flexible(
                      child: Text(
                          dashboardLabel(context,
                              AppLanguageKeys.dashboardAllTimePerformance),
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.darkGreyColor))),
                ]);
              }),
            ])),
        const SizedBox(width: 6),
        Image.asset(AppImageKeys.starsIcons,
            width: 42, height: 60, color: AppColors.orangeColor),
      ]));
}
