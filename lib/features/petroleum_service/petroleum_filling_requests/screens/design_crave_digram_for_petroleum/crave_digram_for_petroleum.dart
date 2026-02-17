import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../features/petroleum_service/petroleum_filling_requests/cubit/chart_cubit.dart';
import '../../../../../features/petroleum_service/petroleum_filling_requests/cubit/chart_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CraveDigramForPetroleum extends StatelessWidget {
  CraveDigramForPetroleum({super.key});

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
    zoomMode: ZoomMode.x,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
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
            final data = state.dataPoints;

            if (data.isEmpty) {
              return const Center(
                child: Text("No Data Available"),
              );
            }

            // ✅ نحول label -> DateTime
            final List<ChartData> chartData =
            data.map((e) {
              final parts = e.label.split(" ");
              final day = int.parse(parts[0]);
              final month = _getMonth(parts[1]);

              return ChartData(
                DateTime(2025, month, day),
                e.value.toDouble(),
              );
            }).toList();

            return SfCartesianChart(
              primaryXAxis: const DateTimeAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                intervalType: DateTimeIntervalType.days,
              ),
              primaryYAxis: const NumericAxis(),
              zoomPanBehavior: _zoomPanBehavior,
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[

                // Area Background
                AreaSeries<ChartData, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (data, _) => data.x,
                  yValueMapper: (data, _) => data.y,
                  color: AppColors.orangeColor.withOpacity(0.2),
                  borderColor: Colors.transparent,
                ),

                // Line
                FastLineSeries<ChartData, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (data, _) => data.x,
                  yValueMapper: (data, _) => data.y,
                  color: AppColors.orangeColor,
                  width: 2,
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }


  int _getMonth(String month) {
    switch (month.toLowerCase()) {
      case "jan":
        return 1;
      case "feb":
        return 2;
      case "mar":
        return 3;
      case "apr":
        return 4;
      case "may":
        return 5;
      case "jun":
        return 6;
      case "jul":
        return 7;
      case "aug":
        return 8;
      case "sep":
        return 9;
      case "oct":
        return 10;
      case "nov":
        return 11;
      case "dec":
        return 12;
      default:
        return 1;
    }
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}
