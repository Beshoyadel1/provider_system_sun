import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/sales_area_chart.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/internal_services/presentation/cubit/loading_dashboard/loading_dashboard_cubit.dart';
import 'package:sun_web_system/features/internal_services/presentation/cubit/loading_dashboard/loading_dashboard_state.dart';

class FastLineWithFillMobileServicesOrders extends StatelessWidget {
  const FastLineWithFillMobileServicesOrders({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
          builder: (context, state) => SizedBox(
                height: 150,
                child: SalesAreaChart(
                  zoomable: true,
                  points: state.chartPoints
                      .map((p) => SalesChartPoint(
                          p.label ?? '', (p.value ?? 0).toDouble()))
                      .toList(),
                  color: AppColors.orangeColor,
                ),
              ));
}
