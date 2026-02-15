import 'package:flutter/material.dart';
import '../../../../../features/cars_haraj_page/model/filter_orders_model/filter_orders_model.dart';
import '../../../../../core/cubit/new_orders_cubit/new_orders_cubit.dart';
import '../../../../../core/theming/colors.dart';
import '../../Internal_services_page/widgets/filters_widget.dart';
import '../../Internal_services_page/widgets/number_indicator.dart';
import '../../Internal_services_page/widgets/search_widget.dart';
import '../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../core/theming/text_styles.dart';
import 'available_cars.dart';

class CarOrdersPage extends StatelessWidget {
  const CarOrdersPage({super.key, required this.cubit});

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
                        text: 'حراج سيارات',
                        textSize: 20,
                        textColor: AppColors.darkColor,
                      ),
                      TextInAppWidget(
                        text:
                            'قائمة السيارت من السيارات الحالية والمباعه سابقا',
                        textSize: 16,
                        textColor: AppColors.darkGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
              FiltersOrdersWidget(filterOptions: filterOptionsCars),
              const SearchWidget(),
              ...List.generate(
                  7,
                  (_) => AvailableCars(
                        spacing: 95,
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
