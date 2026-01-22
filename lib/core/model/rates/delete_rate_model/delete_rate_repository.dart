import 'package:dio/dio.dart';
import '../../../../core/model/rates/delete_rate_model/delete_rate_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteRateFunction({
  required DeleteRateRequest deleteRateRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteRateRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.rate}/DeleteRate",
    );
    AppSnackBar.showSuccess("Delete Rate successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}