import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../features/internal_orders/custom_widget/circular_progress_indicator_with_text_widget.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/logic/loading_dashboard_cubit.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/logic/loading_dashboard_state.dart';
import '../../../../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_interior_services_statistics/container_interior_services_statistics.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_profits_from_ministry_of_interior_services/container_profits_from_ministry_of_interior_services.dart';
import '../../../../../../../../features/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_rate_service/container_rate_service.dart';
import '../../../../../features/internal_orders/first_screen_internal_orders/screens/list_data_first_screen_internal_orders.dart';
import '../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/language/language_constant.dart';


class FirstScreenInternalOrders extends StatelessWidget {
  const FirstScreenInternalOrders({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth && size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;

    return BlocProvider(
      create: (_) => InternalOrdersCubit(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) {
            if (state.isLoading) {
              return const Scaffold(
                body: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                     Center(
                      child: CircularProgressIndicatorWithTextWidget(
                        text: AppLanguageKeys.afterReceivingRequests,
                        textSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }
            return SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Padding(
                      padding:  EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: ListDataFirstScreenInternalOrders(),
                      ),
                    ),
                  ),
                  if ((!isMobile))
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 20,
                            children: [
                              ContainerProfitsFromMinistryOfInteriorServices(),
                              ContainerInteriorServicesStatistics(),
                              ContainerRateService(),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}