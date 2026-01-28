import 'package:dio/dio.dart';
import '../../../../core/model/product/get_products_suitable_for_car_model/get_products_suitable_for_car_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProductsSuitableForCarFunction({
  required GetProductsSuitableForCarRequest getProductsSuitableForCarRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProductsSuitableForCarRequest.toJson(), // params
      ApiLink.getProductsSuitableForCar,
    );
    AppSnackBar.showSuccess("Get Products Suitable For Car successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}