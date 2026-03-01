import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/api_functions/statistics/get_provider_main_service_statistics_model/get_provider_main_service_statistics_request.dart';
import '../../../internal_orders/first_screen_internal_orders/logic/loading_dashboard/loading_dashboard_cubit.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/screens/container_image_title_with_sub_title/first_row_with_two_container_image_and_two_text.dart';
import '../../../../../../features/rates/first_screen_rates/logic/cubit_rates/provider_rates_cubit.dart';
import '../../../../../../features/rates/first_screen_rates/logic/cubit_rates/provider_rates_state.dart';
import '../../../../../../features/rates/first_screen_rates/screens/container_review_data_person_design/list_data_container_review_data_person_design.dart';
import '../../../../../../features/rates/first_screen_rates/screens/title_total_rate_in_list_data_first_screen_rate.dart';
import '../../../../../../features/rates/first_screen_rates/screens/first_title_in_list_data_first_screen_rate.dart';

class ListDataFirstScreenRate extends StatelessWidget {
  const ListDataFirstScreenRate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderRatesCubit, ProviderRatesState>(
      builder: (context, state) {

        if (state is ProviderRatesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProviderRatesError) {
          return Center(child: Text(state.message));
        }

        if (state is ProviderRatesSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              const FirstTitleInListDataFirstScreenRate(),

              BlocProvider(
                  create: (_) => InternalOrdersCubit()
                    ..getStatistics(GetProviderMainServiceStatisticsRequest()),
                  child: const FirstRowWithTwoContainerImageAndTwoText()),

              TitleTotalRateInListDataFirstScreenRate(
                averageRate: state.averageRate,
              ),
              ListDataContainerReviewDataPersonDesign(
                rates: state.rates,
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}