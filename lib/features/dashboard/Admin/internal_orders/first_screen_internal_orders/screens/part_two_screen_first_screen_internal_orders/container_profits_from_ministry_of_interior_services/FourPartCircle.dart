import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/logic/loading_dashboard_cubit.dart';
import '../../../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/logic/loading_dashboard_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FourPartDoughnut extends StatelessWidget {
  const FourPartDoughnut({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
        return SizedBox(
          width: 200,
          child: SfCircularChart(
            margin: EdgeInsets.zero,
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: [
                  ChartData('Part 1', 25, state.isLoaded?AppColors.brownColor:AppColors.greyColor),
                  ChartData('Part 2', 25,  state.isLoaded?AppColors.brownColor:AppColors.greyColor),
                  ChartData('Part 3', 25,AppColors.greyColor),
                  ChartData('Part 4', 25, state.isLoaded?AppColors.brownColor:AppColors.greyColor),
                ],
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelSettings: const DataLabelSettings(isVisible: false),
                innerRadius: '70%',
                strokeColor: AppColors.whiteColor,
                strokeWidth: 1,
              ),
            ],
          ),
        );
      }
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
