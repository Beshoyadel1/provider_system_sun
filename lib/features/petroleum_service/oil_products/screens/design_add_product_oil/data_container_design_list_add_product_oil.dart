import 'package:flutter/cupertino.dart';
import '../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_add_product_oil/container_add_new_oil.dart';
import '../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_add_product_oil/view_list_data_container_design_add_product_oil.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../features/Petroleum_Service/All_Orders_Are_Filled_Petroleum_Filling_Requests/screens/title_with_sub_title_in_all_orders.dart';

class DataContainerDesignListAddProductOil extends StatelessWidget {
  const DataContainerDesignListAddProductOil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TitleWithSubTitleInAllOrders(
                  title: AppLanguageKeys.allDisplayedProducts,
                ),
              ),
              ContainerAddNewOil()
            ],
          ),
          ViewListDataContainerDesignAddProductOil()
        ],
      ),
    );
  }
}
