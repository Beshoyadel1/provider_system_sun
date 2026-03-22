import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:sun_web_system/features/order_status_design/order_details_new_order_emp/order_details_new_order_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_on_the_way_emp/order_details_on_the_way_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_order_received_emp/order_details_order_received_emp.dart';
import 'package:sun_web_system/features/order_status_design/order_details_under_service_emp/order_details_under_service_emp.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../core/api/dio_function/api_constants.dart';

class ContainerDetailsWidget extends StatelessWidget {
  final String? title;
  final int status;
  final Color? backGroundColor, textColor, borderColor;

  const ContainerDetailsWidget({
    super.key,
    required this.status,
    this.title,
    this.textColor,
    this.borderColor,
    this.backGroundColor,
  });

  void _handleNavigation(BuildContext context) {
    switch (status) {
      case OrderStatus.newOrderForProvider:
        Navigator.push(
          context,
          NavigateToPageWidget(
            const OrderDetailsNewOrderEmp(),
          ),
        );
        break;

      case OrderStatus.orderCompleted:
        Navigator.push(
          context,
          NavigateToPageWidget(
            const OrderDetailsOrderReceivedEmp(),
          ),
        );
        break;

      case OrderStatus.employeeInRoad:
        Navigator.push(
          context,
          NavigateToPageWidget(
            const OrderDetailsOnTheWayEmp(),
          ),
        );
        break;

      case OrderStatus.workInProgress:
        Navigator.push(
          context,
          NavigateToPageWidget(
            const OrderDetailsUnderServiceEmp(),
          ),
        );
        break;

      default:
        break;
    }
  }

  bool get _isEnabled {
    return status == OrderStatus.newOrderForProvider ||
        status == OrderStatus.orderCompleted ||
        status == OrderStatus.employeeInRoad ||
        status == OrderStatus.workInProgress;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isEnabled ? () => _handleNavigation(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: _isEnabled
              ? (backGroundColor ?? AppColors.whiteColor)
              : AppColors.greyColor.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: _isEnabled
                ? (borderColor ?? AppColors.orangeColor)
                : AppColors.greyColor,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: TextInAppWidget(
            text: title ?? AppLanguageKeys.details,
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: _isEnabled
                ? (textColor ?? AppColors.orangeColor)
                : AppColors.greyColor,
          ),
        ),
      ),
    );
  }
}