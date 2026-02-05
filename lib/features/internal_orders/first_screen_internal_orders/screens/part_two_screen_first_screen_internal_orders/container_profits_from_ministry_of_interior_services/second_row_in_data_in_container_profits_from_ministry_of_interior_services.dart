import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../features/internal_orders/custom_widget/row_circle_color_text_percentage_widget.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/logic/loading_dashboard_cubit.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/logic/loading_dashboard_state.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_profits_from_ministry_of_interior_services/FourPartCircle.dart';

class SecondRowInDataInContainerProfitsFromMinistryOfInteriorServices
    extends StatelessWidget {
  const SecondRowInDataInContainerProfitsFromMinistryOfInteriorServices(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10,
      children: [
         Flexible(child: FourPartDoughnut()),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowCircleColorTextPercentageWidget(
              colorCircle: AppColors.brownColor,
              text: AppLanguageKeys.maintenanceAndRepair,
              percentage: '25' ,
            ),
            RowCircleColorTextPercentageWidget(
              colorCircle: AppColors.lightBlueColor,
              text: AppLanguageKeys.oilChange,
              percentage:'25' ,
            ),
          ],
        ),
      ],
    );
  }
}
