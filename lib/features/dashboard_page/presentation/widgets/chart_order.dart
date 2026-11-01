import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'custom_line_chart.dart';
import 'dashboard_widgets.dart';

class ChartOrder extends StatelessWidget {
  const ChartOrder({super.key, this.onRetry});
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => DashboardPanel(
      height: 438,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const DashboardTitle(AppLanguageKeys.dashboardOrderSales),
        const SizedBox(height: 26),
        Expanded(child: CustomLineChart(onRetry: onRetry)),
      ]));
}
