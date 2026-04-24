import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/car_model_data_model.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/get_car_brand_models_repository.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/get_car_brand_models_request.dart';

class CarSelectionCubit extends Cubit<void> {
  CarSelectionCubit() : super(null);

  final Map<int, List<CarModelDataModel>> cache = {};

  Future<List<CarModelDataModel>> getModels(int brandId) async {
    if (cache.containsKey(brandId)) {
      return cache[brandId]!;
    }

    final data = await getCarBrandModelsFunction(
      request: GetCarBrandModelsRequest(carBrandId: brandId),
    );

    cache[brandId] = data;
    return data;
  }
}