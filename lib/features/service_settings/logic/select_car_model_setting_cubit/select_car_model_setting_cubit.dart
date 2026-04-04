import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_brand/get_car_brand_models_model/get_car_brand_repository.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/get_car_brand_models_repository.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/get_car_brand_models_request.dart';
import 'select_car_model_setting_state.dart';

class SelectCarModelSettingCubit
    extends Cubit<SelectCarModelSettingState> {
  SelectCarModelSettingCubit()
      : super(SelectCarModelSettingState());

  Future<void> fetchBrands() async {
    emit(state.copyWith(isLoadingBrands: true));

    try {
      final data = await getCarBrandFunction();

      emit(state.copyWith(
        isLoadingBrands: false,
        brands: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingBrands: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> selectBrand(int index) async {
    emit(state.copyWith(
      selectedBrandIndex: index,
      selectedModelIndex: -1, // reset model
      isLoadingModels: true,
      models: [],
    ));

    try {
      final brandId = state.brands[index].id;

      if (brandId == null) return;

      final data = await getCarBrandModelsFunction(
        request: GetCarBrandModelsRequest(carBrandId: brandId),
      );

      emit(state.copyWith(
        isLoadingModels: false,
        models: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingModels: false,
        error: e.toString(),
      ));
    }
  }

  void selectModel(int index) {
    emit(state.copyWith(selectedModelIndex: index));
  }
}