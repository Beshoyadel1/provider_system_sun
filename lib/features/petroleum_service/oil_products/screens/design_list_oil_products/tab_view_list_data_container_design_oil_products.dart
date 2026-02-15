import 'package:flutter/cupertino.dart';
import '../../../custom_widget/number_of_text_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../features/internal_orders/custom_widget/container_details_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/column_subscription_fees_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/column_packing_date_widget.dart';
import '../../../../../../../../features/Petroleum_Service/custom_widget/row_name_emp_widget.dart';

class TabViewListDataContainerDesignOilProducts extends StatelessWidget {
  const TabViewListDataContainerDesignOilProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NumberOfTextWidget(),
        RowNameEmpWidget(
          imagePath: AppImageKeys.testOil,
          title: AppLanguageKeys.oils,
          textColorTitle: AppColors.orangeColor,
          textSizeTitle: 14,
          subTitle: 'Name Oil Car',
          textColorSubTitle: AppColors.blackColor,
        ),
        ColumnPackingDateWidget(
          title: AppLanguageKeys.saleDate,
          subTitle: '1/1/2025',
        ),
        ColumnSubscriptionFeesWidget(
          title: AppLanguageKeys.productPrice,
        ),
        ContainerDetailsWidget(),
      ],
    );
  }
}
