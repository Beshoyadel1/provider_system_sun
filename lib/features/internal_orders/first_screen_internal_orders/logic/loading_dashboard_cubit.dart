import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api_functions/statistics/get_provider_main_service_statistics_model/get_provider_main_service_statistics_repository.dart';
import '../../../../../features/internal_orders/first_screen_internal_orders/logic/loading_dashboard_state.dart';

class InternalOrdersCubit extends Cubit<InternalOrdersState> {
  InternalOrdersCubit() : super(const InternalOrdersState());

  Future<void> getStatistics(request) async {
    emit(state.copyWith(
      isLoading: true,
      isLoaded: false,
    ));

    final result =
    await getProviderMainServiceStatisticsFunction(request: request);

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      services: result.services,
      averageRate: result.averageRate,
      chartPoints: result.chartPoints,
    ));
  }
}
