import 'package:flutter/cupertino.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../features/Petroleum_Service/All_Orders_Are_Filled_Petroleum_Filling_Requests/screens/title_with_sub_title_in_all_orders.dart';
import '../../../../../../../features/Petroleum_Service/Oil_Products/screens/design_list_oil_products/view_list_data_container_design_oil_products.dart';

class DataContainerDesignListOilProducts extends StatelessWidget {
  const DataContainerDesignListOilProducts({
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
          TitleWithSubTitleInAllOrders(
            title: AppLanguageKeys.allSoldProducts,
          ),
          ViewListDataContainerDesignOilProducts()
        ],
      ),
    );
  }
}
