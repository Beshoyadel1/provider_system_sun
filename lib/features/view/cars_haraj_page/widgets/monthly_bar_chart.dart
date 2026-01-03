import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../core/theming/text_styles.dart';

class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomContainer(
              isSelected: false,
              onTap: () {},
              typeWidget: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TextInAppWidget(text: 'مبيعات حراج سيارات', textSize: 16, fontWeightIndex: FontSelectionData.regularFontFamily,),
                  const TextInAppWidget(text:AppLanguageKeys.priceKey, textSize: 16, fontWeightIndex: FontSelectionData.regularFontFamily,textColor: AppColors.orangeColor,),

      SizedBox(
        height: 178,
        child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 5,
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox();
                              final labels = {
                                0.1: '100k',
                                0.5: '500k',
                                1: '1m',
                                2: '2m',
                                3: '3m',
                                4: '4m',
                                5: '5m',
                              };
                              return Text(
                                labels[value] ?? '',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const months = [
                                'يناير',
                                'فبراير',
                                'مارس',
                                'ابريل',
                                'يونيو',
                                'مايو',
                                'يوليو',
                                'اغسطس',
                                'يناير',
                                'فبراير',
                                'مارس',
                                'ابريل',
                                'يونيو'
                              ];
                              return Text(
                                months[value.toInt() % months.length],
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: _barGroups(),
                    ),
                  ),)
                ],

        ),

    );
  }

  List<BarChartGroupData> _barGroups() {
    final List<double> values = [3.0, 2.0, 4.5, 2.5, 5.0, 0.5, 3.0, 2.0, 4.5, 3.0, 4.0, 5.0];
    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            width: 18,
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: [
                AppColors.orangeColor,
                AppColors.darkorangeColor,
                AppColors.secondaryColor,
              ],
            ),
          ),
        ],
      );
    });
  }

}
