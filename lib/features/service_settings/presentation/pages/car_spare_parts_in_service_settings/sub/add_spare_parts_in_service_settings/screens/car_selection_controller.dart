import 'package:sun_web_system/features/service_settings/data/model/get_car_brand_models/car_model_data_model.dart';

class CarSelectionController {
  int? brandId;

  List<int> selectedModelIds = [];
  List<CarModelDataModel> models = [];

  bool isLoading = false;

  bool isAllBrandsSelected = false;
}