import 'package:flutter/material.dart';
import '../../../../../../../../core/api_functions/statistics/get_provider_petrol_sales_chart_model/petrol_chart_point.dart';
import '../../../../../../../../features/petroleum_service/petroleum_filling_requests/cubit/chart_cubit.dart';
import '../../../../../../../../features/petroleum_service/petroleum_filling_requests/cubit/chart_state.dart';
import '../../../../../../../../core/theming/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DigramForPetroleum extends StatelessWidget {
  const DigramForPetroleum({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BlocBuilder<PetrolChartCubit, PetrolChartState>(
        builder: (context, state) {


          if (state is PetrolChartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          if (state is PetrolChartError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is PetrolChartSuccess) {
            final List<PetrolChartPoint> data =
                state.dataPoints;

            return SfCartesianChart(
              margin: EdgeInsets.zero,

              primaryXAxis: const CategoryAxis(
                labelRotation: -45,
                majorGridLines:
                 MajorGridLines(width: 0),
              ),

              primaryYAxis: const NumericAxis(
                majorGridLines:
                 MajorGridLines(width: 0.5),
              ),

              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x : point.y',
              ),

              series: <CartesianSeries>[
                ColumnSeries<PetrolChartPoint, String>(
                  dataSource: data,
                  xValueMapper:
                      (PetrolChartPoint point, _) =>
                  point.label,
                  yValueMapper:
                      (PetrolChartPoint point, _) =>
                      point.value.toDouble(),
                  width: 0.4,
                  spacing: 0.2,
                  color: AppColors.orangeColor,
                  borderRadius:
                  const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  animationDuration: 800,
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class ColumnChartData {
  ColumnChartData(this.x, this.y);

  final int x;
  final double y;
}
