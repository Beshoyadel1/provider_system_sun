import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/employee/presentation/pages/sign_up_page_emp/sign_up_page_emp.dart';
import 'package:sun_web_system/features/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';

class TitleViewEmployeeData extends StatelessWidget {
  const TitleViewEmployeeData({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            TextInAppWidget(
              text: AppLanguageKeys.employees,
              textSize: 18,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.blackColor,
            ),
            TextInAppWidget(
              text: AppLanguageKeys.allRegisteredEmployeesInFacility ,
              textSize: 18,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.blackColor,
            ),
          ],
        )),
        ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
          text: AppLanguageKeys.createEmployee,
          onTap: (){
            Navigator.push(
              context,
              NavigateToPageWidget(
                const SignUpPageEmp(),
              ),
            );
          },
        )
      ],
    );
  }
}
