import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../../../features/Internal_services_page/widgets/build_legend_item.dart';
import '../../../../../../../features/cars_haraj_page/model/chart_data_model/chart_data_model.dart';
import '../../../../../../../core/theming/colors.dart';


class DonutChartAndLegend extends StatelessWidget {
 const DonutChartAndLegend({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 147,
              width: 147,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.veryLightGreyColor,
                          width: 39,
                        ),
                      ),
                    ),
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius:50,
                        startDegreeOffset: 270,
                        sections: data.map((item) {
                          return PieChartSectionData(
                            color: item.color,
                            value: item.percentage.toDouble(),
                            title: '',
                            radius: 12,

                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
           Expanded(
             child: Wrap(
               spacing: 5,
               runSpacing: 5,
               children: data.map((item) => BuildLegendItem( item: item,)).toList(),),
           ),

          ],
        ),

    );
  }


}


