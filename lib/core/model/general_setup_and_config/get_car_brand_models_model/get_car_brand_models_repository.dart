import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/get_car_brand_models_model/get_car_brand_models_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCarBrandModelsFunction({
  required GetCarBrandModelsRequest getCarBrandModelsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCarBrandModelsRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.carModel}/GetCarBrandModels",
    );
    AppSnackBar.showSuccess("Get Car Brand Models successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
