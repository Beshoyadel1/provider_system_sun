import 'package:sun_web_system/features/petroleum_service/data/model/get_provider_petrol_sales_chart_model/petrol_chart_point.dart';

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
