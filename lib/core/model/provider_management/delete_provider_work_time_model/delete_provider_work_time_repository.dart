import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/delete_provider_work_time_model/delete_provider_work_time_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteProviderWorkTimeFunction({
  required DeleteProviderWorkTimeRequest deleteProviderWorkTimeRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteProviderWorkTimeRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.workTIme}/DeleteProviderWorkTime",
    );
    AppSnackBar.showSuccess("Delete Provider Work Time successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}