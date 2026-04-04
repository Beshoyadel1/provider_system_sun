import 'package:sun_web_system/core/api_functions/general/car/car_brand/get_car_brand_models_model/car_brand_data_model.dart';

abstract class CarBrandState {}

class CarBrandInitial extends CarBrandState {}

class CarBrandLoading extends CarBrandState {}

class CarBrandSuccess extends CarBrandState {
  final List<CarBrandDataModel> brands;

  CarBrandSuccess(this.brands);
}

class CarBrandError extends CarBrandState {
  final String message;

  CarBrandError(this.message);
}