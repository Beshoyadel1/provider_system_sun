import 'package:flutter/material.dart';
import '../../Internal_services_page/widgets/profits_services.dart';
import '../../dashboard_page/widgets/services_evaluation.dart';
import '../../dashboard_page/widgets/services_statistics.dart';
import '../widgets/list_of_cars.dart';
import '../widgets/monthly_bar_chart.dart';

class CarsHarajStatisticsPage extends StatelessWidget {
  const CarsHarajStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SingleChildScrollView(
            child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.center,
                children: [
          SizedBox(
              width: 860,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.center,
                children: [
                  MonthlyBarChart(),
                  ListOfCars(),
                ],
              )),
          SizedBox(
            width: 375,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ServicesStatistics(),
                ProfitsServices(),
                ServicesEvaluation(),
              ],
            ),
          )
        ])));
  }
}
