import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import '../../data/model/dashboard_service.dart';
import '../cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_cubit.dart';
import '../cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_state.dart';
import 'custom_chart.dart';
import 'dashboard_widgets.dart';

class ListCustomChart extends StatelessWidget {
  const ListCustomChart({super.key, this.onRetry});
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => BlocBuilder<
          GetProviderServiceStatisticsCubit,
          GetProviderServiceStatisticsState>(builder: (context, state) {
        if (state is GetProviderServiceStatisticsError) {
          return DashboardPanel(
              child: DashboardFeedback(failed: true, onRetry: onRetry));
        }
        return LayoutBuilder(builder: (context, constraints) {
          const gap = 14.0;
          final width = ((constraints.maxWidth - gap * 4) / 5)
              .clamp(205.0, double.infinity);
          final success =
              state is GetProviderServiceStatisticsSuccess ? state : null;
          final cards = {
            for (final card in success?.data.summaryCards ?? [])
              card.resolvedServiceId: card
          };
          final row =
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final service in DashboardService.all) ...[
              if (service.id != DashboardService.all.first.id)
                const SizedBox(width: gap),
              SizedBox(
                  width: width,
                  child: CustomChart(
                    key: ValueKey('dashboard-service-${service.id}'),
                    serviceId: service.id,
                    serviceName: LanguageCubit.localizedValue(
                        context,
                        cards[service.id]?.serviceName ?? service.arabic,
                        cards[service.id]?.serviceLatinName ?? service.english),
                    orderCount: cards[service.id]?.orderCount,
                    totalAmount: cards[service.id]?.totalAmount,
                    percentage: cards[service.id]?.percentageChange,
                    isIncrease: cards[service.id]?.isIncrease,
                    points: success?.charts[service.id]?.points ?? [],
                    loading: success == null ||
                        success.charts[service.id]?.loading == true,
                    failed: success?.charts[service.id]?.failed == true,
                  )),
            ],
          ]);
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: row);
        });
      });
}
