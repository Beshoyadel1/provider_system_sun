import 'package:sun_web_system/core/api_functions/general/car/car_model/get_car_brand_models/car_model_data_model.dart';

class CarSelectionController {
  int? brandId;
  int? modelId;

  List<CarModelDataModel> models = [];
  bool isLoading = false;

  int? categoryId;
  String? categoryName;
}