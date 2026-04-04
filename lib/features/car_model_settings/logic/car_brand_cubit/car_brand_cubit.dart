import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_brand/get_car_brand_models_model/get_car_brand_repository.dart';
import 'package:sun_web_system/features/car_model_settings/logic/car_brand_cubit/car_brand_state.dart';

class CarBrandCubit extends Cubit<CarBrandState> {
  CarBrandCubit() : super(CarBrandInitial());

  Future<void> fetchBrands() async {
    emit(CarBrandLoading());

    try {
      final brands = await getCarBrandFunction();

      emit(CarBrandSuccess(brands));
    } catch (e) {
      emit(CarBrandError(e.toString()));
    }
  }
}