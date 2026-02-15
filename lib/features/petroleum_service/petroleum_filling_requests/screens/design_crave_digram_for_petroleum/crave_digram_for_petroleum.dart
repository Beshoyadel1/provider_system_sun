import 'package:flutter/material.dart';
import '../../../../../../../../core/theming/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CraveDigramForPetroleum extends StatelessWidget {
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
    zoomMode: ZoomMode.x,
  );

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(DateTime(2025, 1, 1), 2),
      ChartData(DateTime(2025, 1, 2), 4),
      ChartData(DateTime(2025, 1, 3), 3),
      ChartData(DateTime(2025, 1, 4), 6),
      ChartData(DateTime(2025, 1, 5), 5),
      ChartData(DateTime(2025, 1, 6), 8),
    ];

    return Container(
      height: 250,
      padding: const EdgeInsets.all(8),
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.days,
        ),
        primaryYAxis: NumericAxis(),
        zoomPanBehavior: _zoomPanBehavior,
        series: <CartesianSeries>[
          AreaSeries<ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            color: Colors.pink.withOpacity(0.3),
            borderColor: Colors.transparent,
          ),
          FastLineSeries<ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            color: AppColors.orangeColor,
            width: 2,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}
