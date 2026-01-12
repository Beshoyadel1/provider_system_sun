import 'package:flutter/material.dart';
import '../../../../../../../../core/theming/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DigramForPetroleum extends StatelessWidget {
  const DigramForPetroleum({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ColumnChartData> chartData = [
      ColumnChartData(1, 35),
      ColumnChartData(2, 23),
      ColumnChartData(3, 34),
      ColumnChartData(4, 25),
      ColumnChartData(5, 40),
      ColumnChartData(6, 10),
      ColumnChartData(7, 20),
      ColumnChartData(8, 30),
    ];

    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        series: <CartesianSeries>[
          ColumnSeries<ColumnChartData, int>(
            dataSource: chartData,
            xValueMapper: (ColumnChartData data, _) => data.x,
            yValueMapper: (ColumnChartData data, _) => data.y,
            width: 0.3,
            spacing: 0.2,
            color: AppColors.orangeColor,
          ),
        ],
      ),
    );
  }
}

class ColumnChartData {
  ColumnChartData(this.x, this.y);

  final int x;
  final double y;
}
