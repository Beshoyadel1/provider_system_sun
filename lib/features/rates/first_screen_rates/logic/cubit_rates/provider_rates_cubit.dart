import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/rates/get_provider_details_rates_model/get_provider_details_rates_repository.dart';
import 'package:sun_web_system/core/api_functions/rates/get_provider_details_rates_model/get_provider_details_rates_request.dart';
import 'package:sun_web_system/core/api_functions/rates/get_provider_details_rates_model/rate_item.dart';
import 'package:sun_web_system/features/rates/first_screen_rates/logic/cubit_rates/provider_rates_state.dart';

class ProviderRatesCubit extends Cubit<ProviderRatesState> {
  ProviderRatesCubit() : super(ProviderRatesInitial());

  Future<void> getProviderRates({
    required int providerId,
    int? serviceId,
  }) async {
    emit(ProviderRatesLoading());

    try {
      final response = await getProviderDetailsRatesFunction(
        request: GetProviderDetailsRatesRequest(
          providerId: providerId,
          serviceId: serviceId,
        ),
      );

      final List<RateItem> allRates =
      response.rates
          .expand<RateItem>((service) => service.rates)
          .toList();


      emit(
        ProviderRatesSuccess(
          averageRate: response.averageRate,
          rates: allRates,
        ),
      );
    } catch (e) {
      emit(ProviderRatesError(e.toString()));
    }
  }
}