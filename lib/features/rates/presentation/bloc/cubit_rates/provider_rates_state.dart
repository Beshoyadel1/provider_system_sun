import 'package:sun_web_system/features/rates/data/model/get_provider_details_rates_model/rate_item.dart';

abstract class ProviderRatesState {}

class ProviderRatesInitial extends ProviderRatesState {}

class ProviderRatesLoading extends ProviderRatesState {}

class ProviderRatesSuccess extends ProviderRatesState {
  final int averageRate;
  final List<RateItem> rates;

  ProviderRatesSuccess({
    required this.averageRate,
    required this.rates,
  });
}

class ProviderRatesError extends ProviderRatesState {
  final String message;

  ProviderRatesError(this.message);
}