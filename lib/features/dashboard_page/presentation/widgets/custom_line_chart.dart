import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/sales_area_chart.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_cubit.dart';
import '../cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_state.dart';
import 'dashboard_widgets.dart';

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({super.key, this.onRetry});
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GetProviderOrdersSalesCubit, GetProviderOrdersSalesState>(
          builder: (context, state) {
        if (state is GetProviderOrdersSalesError) {
          return DashboardFeedback(failed: true, onRetry: onRetry);
        }
        if (state is! GetProviderOrdersSalesSuccess) {
          return const DashboardFeedback(loading: true);
        }
        if (state.data.dataPoints.isEmpty) {
          return const DashboardFeedback(
              message: AppLanguageKeys.dashboardNoSales);
        }
        return SalesAreaChart(
          points: state.data.dataPoints
              .map((p) => SalesChartPoint(p.label, p.value))
              .toList(),
          color: AppColors.seaBlueColor,
          valueSuffix: dashboardLabel(context, AppLanguageKeys.sar),
        );
      });
}
