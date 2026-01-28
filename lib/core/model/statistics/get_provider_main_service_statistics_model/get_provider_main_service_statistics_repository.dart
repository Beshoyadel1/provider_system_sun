import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_provider_main_service_statistics_model/get_provider_main_service_statistics_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderMainServiceStatisticsFunction({
  required GetProviderMainServiceStatisticsRequest getProviderMainServiceStatisticsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderMainServiceStatisticsRequest.toJson(), // params
      ApiLink.getProviderMainServiceStatistics,
    );
    AppSnackBar.showSuccess("Get Provider Main Service Statistics successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}