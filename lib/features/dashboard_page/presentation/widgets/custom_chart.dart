import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/sales_area_chart.dart';
import '../../data/model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';
import 'dashboard_widgets.dart';

class CustomChart extends StatelessWidget {
  const CustomChart(
      {super.key,
      required this.serviceId,
      required this.serviceName,
      this.orderCount,
      this.totalAmount,
      this.percentage,
      this.isIncrease,
      this.points = const [],
      this.loading = false,
      this.failed = false});
  final int serviceId;
  final String serviceName;
  final int? orderCount;
  final double? totalAmount;
  final double? percentage;
  final bool? isIncrease;
  final List<DataPoint> points;
  final bool loading;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final color = dashboardServiceColor(serviceId);
    final direction = percentage == null || percentage == 0
        ? 0
        : (isIncrease == true
            ? 1
            : isIncrease == false
                ? -1
                : 0);
    return DashboardPanel(
      height: 238,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: .14),
              child: Icon(dashboardServiceIcon(serviceId),
                  size: 17, color: color)),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(serviceName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.5)),
                const SizedBox(height: 3),
                Text(
                    '${orderCount ?? '—'} ${dashboardLabel(context, AppLanguageKeys.dashboardOrdersShort)}',
                    style: TextStyle(fontSize: 11, color: color)),
              ])),
        ]),
        const SizedBox(height: 10),
        Expanded(
            child: loading || failed || points.isEmpty
                ? DashboardFeedback(
                    loading: loading,
                    failed: failed,
                    message: failed
                        ? AppLanguageKeys.dashboardChartUnavailable
                        : AppLanguageKeys.dashboardNoSales)
                : SalesAreaChart(
                    points: points
                        .map((p) => SalesChartPoint(p.label, p.value))
                        .toList(),
                    color: color,
                    compact: true)),
        const SizedBox(height: 8),
        Wrap(
            spacing: 10,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                  '${dashboardMoney(totalAmount)} ${dashboardLabel(context, AppLanguageKeys.sar)}',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: color)),
              if (percentage != null)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                      direction > 0
                          ? Icons.north_east_rounded
                          : direction < 0
                              ? Icons.south_east_rounded
                              : Icons.east_rounded,
                      size: 13,
                      color: direction < 0
                          ? const Color(0xFFD75D62)
                          : direction > 0
                              ? const Color(0xFF2D9B76)
                              : Colors.grey),
                  const SizedBox(width: 3),
                  Text('${percentage!.abs().toStringAsFixed(1)}%',
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFF737B87))),
                ]),
            ]),
      ]),
    );
  }
}
