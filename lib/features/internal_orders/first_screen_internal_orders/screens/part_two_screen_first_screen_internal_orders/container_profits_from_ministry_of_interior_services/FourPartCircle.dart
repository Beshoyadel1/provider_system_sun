import 'package:flutter/material.dart';
import '../../../../../../../../core/theming/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FourPartDoughnut extends StatelessWidget {
  final List services;

  const FourPartDoughnut({
    super.key,
    required this.services,
  });

  bool get _isEmpty => services.isEmpty;

  bool get _allZero {
    if (_isEmpty) return true;
    return services.every((s) => (s.orderCount ?? 0) == 0);
  }

  List<ChartData> get _chartData {
    if (_isEmpty) {
      return [
        ChartData('', 25, AppColors.lightGreyColor),
      ];
    }
    if (_allZero) {
      return services.asMap().entries.map((entry) {
        final index = entry.key;
        final service = entry.value;

        final title =
            service.serviceName ??
                service.serviceLatinName ??
                '';

        return ChartData(
          title,
          25,
          legendColor(index),
        );
      }).toList();
    }

    return services.asMap().entries.map((entry) {
      final index = entry.key;
      final service = entry.value;

      final title =
          service.serviceName ??
              service.serviceLatinName ??
              '';

      final double count =
      (service.orderCount ?? 0).toDouble();

      return ChartData(
        title,
        count,
        legendColor(index),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 149,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
            dataSource: _chartData,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            innerRadius: '70%',
            strokeColor: AppColors.whiteColor,
            strokeWidth: 1,
            dataLabelSettings:
            const DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
Color legendColor(int index) {
  const colors = [
    AppColors.brownColor,
    AppColors.lightBlueColor,
    AppColors.greenColor,
    AppColors.orangeColor,
    AppColors.purpleColor,
  ];

  return colors[index % colors.length];
}
