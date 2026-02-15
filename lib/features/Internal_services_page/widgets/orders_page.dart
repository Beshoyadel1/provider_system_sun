import 'package:flutter/material.dart';
import '../../../../../features/cars_haraj_page/model/filter_orders_model/filter_orders_model.dart';
import '../../../../../core/cubit/new_orders_cubit/new_orders_cubit.dart';
import '../../../../../core/language/language_constant.dart';
import 'search_widget.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../core/theming/text_styles.dart';
import 'filters_widget.dart';
import 'new_order_widget.dart';
import 'number_indicator.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, required this.cubit});

  final NewOrdersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      typeWidget: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInAppWidget(
                        text: AppLanguageKeys.allOrdersKey,
                        textSize: 20,
                        textColor: AppColors.darkColor,
                      ),
                      TextInAppWidget(
                        text: AppLanguageKeys.ordersListFromServicesKey,
                        textSize: 16,
                        textColor: AppColors.darkGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
              FiltersOrdersWidget(
                filterOptions: filterOrders,
              ),
              const SearchWidget(),
              ...List.generate(
                  7,
                  (_) => NewOrderWidget(
                        spacing: 25,
                        onTap: () {
                          cubit.showOrderDetails();
                        },
                      )),
              Center(child: NumberIndicator())
            ],
          ),
        ),
      ),
    );
  }
}
