import 'package:flutter/cupertino.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../features/internal_orders/custom_widget/container_details_widget.dart';
import '../../../../../features/Petroleum_Service/custom_widget/column_subscription_fees_widget.dart';
import '../../../../../features/Petroleum_Service/custom_widget/column_packing_date_widget.dart';
import '../../../../../features/Petroleum_Service/custom_widget/row_main_branch_widget.dart';
import '../../../../../features/Petroleum_Service/custom_widget/row_name_emp_widget.dart';

class MobileViewListDataContainerDesignNewOrderPetroleum extends StatelessWidget {
  final String? nameEmp, date, quantity, price;
  const MobileViewListDataContainerDesignNewOrderPetroleum({
    super.key,
    this.date,
    this.nameEmp,
    this.price,
    this.quantity
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RowNameEmpWidget(
              title: AppLanguageKeys.employeeName,
              subTitle: nameEmp,
            ),
            const RowMainBranchWidget(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColumnPackingDateWidget(
              title: AppLanguageKeys.fillingDate,
              subTitle: date,
            ),
            ColumnPackingDateWidget(
              title: AppLanguageKeys.filling,
              subTitle: quantity,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColumnSubscriptionFeesWidget(
              title: AppLanguageKeys.price,
              budget: price,
            ),
            const ContainerDetailsWidget(),
          ],
        ),
      ],
    );
  }
}
