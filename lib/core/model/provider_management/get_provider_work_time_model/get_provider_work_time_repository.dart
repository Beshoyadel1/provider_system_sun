import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/get_provider_work_time_model/get_provider_work_time_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderWorkTimeFunction({
  required GetProviderWorkTimeRequest getProviderWorkTimeRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderWorkTimeRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.workTIme}/GetProviderWorkTime",
    );
    AppSnackBar.showSuccess("Get Provider Work Time successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}