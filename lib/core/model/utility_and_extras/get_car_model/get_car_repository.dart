import 'package:dio/dio.dart';
import '../../../../core/model/utility_and_extras/get_car_model/get_car_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCarFunction({
  required GetCarRequest getCarRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCarRequest.toJson(), // params
      ApiLink.getCar,
    );
    AppSnackBar.showSuccess("Get Car successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}