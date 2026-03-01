import 'package:dio/dio.dart';
import '../../../../../../core/api_functions/general/car/car_brand/get_car_brand_models_model/get_car_brand_models_request.dart';
import '../../../../../../core/api/dio_function/apiRoutes.dart';
import '../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';

Future<void> getCarBrandModelsFunction({
  required GetCarBrandModelsRequest getCarBrandModelsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCarBrandModelsRequest.toJson(),
      ApiLink.getCarBrandModels,
    );
    AppSnackBar.showSuccess(AppLanguageKeys.getCarBrandModelsSuccessfully);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}