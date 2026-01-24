import 'package:dio/dio.dart';
import '../../../../core/model/company_management/delete_car_group_model/delete_car_group_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteCarGroupFunction({
  required DeleteCarGroupRequest deleteCarGroupRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteCarGroupRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.carGroup}/DeleteCarGroup",
    );
    AppSnackBar.showSuccess("Delete Car Group successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
