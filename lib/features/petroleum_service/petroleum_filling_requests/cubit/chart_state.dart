import '../../../../core/api_functions/statistics/get_provider_petrol_sales_chart_model/petrol_chart_point.dart';

abstract class PetrolChartState {}

class PetrolChartInitial extends PetrolChartState {}

class PetrolChartLoading extends PetrolChartState {}

class PetrolChartSuccess extends PetrolChartState {
  final List<PetrolChartPoint> dataPoints;

  PetrolChartSuccess(this.dataPoints);
}

class PetrolChartError extends PetrolChartState {
  final String message;

  PetrolChartError(this.message);
}
