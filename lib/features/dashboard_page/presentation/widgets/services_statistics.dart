import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/car_model_widget/widgets/donut_chart_and_legend.dart';
import '../cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_cubit.dart';
import '../cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_state.dart';
import 'dashboard_widgets.dart';

class ServicesStatistics extends StatelessWidget {
  const ServicesStatistics({super.key})
      : general = false,
        onRetry = null;
  const ServicesStatistics.general({super.key, this.onRetry}) : general = true;
  final bool general;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    // Existing marketplace consumers retain their own data source.
    if (!general) {
      return const DashboardPanel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DashboardTitle(AppLanguageKeys.internalServicesStatsKey),
        SizedBox(height: 24),
        DonutChartAndLegend(),
      ]));
    }
    return DashboardPanel(
        height: 244,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const DashboardTitle(AppLanguageKeys.dashboardServiceDistribution),
          const SizedBox(height: 18),
          Expanded(child: BlocBuilder<GetProviderServiceStatisticsCubit,
              GetProviderServiceStatisticsState>(builder: (context, state) {
            if (state is GetProviderServiceStatisticsError) {
              return DashboardFeedback(failed: true, onRetry: onRetry);
            }
            if (state is! GetProviderServiceStatisticsSuccess) {
              return const DashboardFeedback(loading: true);
            }
            final data = state.data.chart;
            if (data.isEmpty || data.every((item) => item.percentage == 0)) {
              return const DashboardFeedback();
            }
            return Row(children: [
              SizedBox(
                  width: 120,
                  height: 148,
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                        width: 116,
                        height: 116,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFF0F2FA), width: 23))),
                    PieChart(PieChartData(
                        centerSpaceRadius: 39,
                        sectionsSpace: 0,
                        startDegreeOffset: 270,
                        pieTouchData: PieTouchData(enabled: false),
                        sections: data
                            .where((item) => item.percentage > 0)
                            .map((item) => PieChartSectionData(
                                  value: item.percentage,
                                  color: dashboardServiceColor(item.serviceId),
                                  radius: 11,
                                  showTitle: false,
                                ))
                            .toList())),
                  ])),
              const SizedBox(width: 12),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: data
                              .map((item) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(children: [
                                      Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                              color: dashboardServiceColor(
                                                  item.serviceId),
                                              shape: BoxShape.circle)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                          child: Text(
                                              LanguageCubit.localizedValue(
                                                  context,
                                                  item.serviceName,
                                                  item.serviceLatinName),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 10, height: 1.5))),
                                      const SizedBox(width: 5),
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFF5F6F9),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                              '${item.percentage.toStringAsFixed(item.percentage % 1 == 0 ? 0 : 1)}%',
                                              textDirection: TextDirection.ltr,
                                              style: const TextStyle(
                                                  fontSize: 9))),
                                    ]),
                                  ))
                              .toList()))),
            ]);
          })),
        ]));
  }
}
