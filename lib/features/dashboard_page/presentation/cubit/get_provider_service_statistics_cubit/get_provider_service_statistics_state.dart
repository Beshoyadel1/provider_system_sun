import '../../../data/model/get_provider_service_statistics_model/provider_statistics_model.dart';
import '../../../data/model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';

abstract class GetProviderServiceStatisticsState {}

class GetProviderServiceStatisticsInitial
    extends GetProviderServiceStatisticsState {}

class GetProviderServiceStatisticsLoading
    extends GetProviderServiceStatisticsState {}

class ServiceChartState {
  const ServiceChartState(
      {this.points = const [], this.loading = false, this.failed = false});
  final List<DataPoint> points;
  final bool loading;
  final bool failed;
}

class GetProviderServiceStatisticsSuccess
    extends GetProviderServiceStatisticsState {
  GetProviderServiceStatisticsSuccess(this.data, {this.charts = const {}});
  final ProviderStatisticsModel data;
  final Map<int, ServiceChartState> charts;
}

class GetProviderServiceStatisticsError
    extends GetProviderServiceStatisticsState {
  GetProviderServiceStatisticsError(this.message);
  final String message;
}
