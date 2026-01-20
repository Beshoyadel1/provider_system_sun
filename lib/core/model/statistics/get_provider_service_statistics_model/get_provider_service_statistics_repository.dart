import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_provider_service_statistics_model/get_provider_service_statistics_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderServiceStatisticsFunction({
  required GetProviderServiceStatisticsRequest getProviderServiceStatisticsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderServiceStatisticsRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.statistics}/GetProviderServiceStatistics",
    );
    AppSnackBar.showSuccess("Get Provider Service Statistics successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
