import 'package:dio/dio.dart';
import '../../../../core/model/company_management/add_car_to_group_model/add_car_to_group_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> addCarToGroupFunction({
  required AddCarToGroupRequest addCarToGroupRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      addCarToGroupRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.carGroup}/AddCarToGroup",
    );
    AppSnackBar.showSuccess("Add Car To Group successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}