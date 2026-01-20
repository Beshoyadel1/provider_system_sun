import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_company_general_statistics_model/get_company_general_statistics_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCompanyGeneralStatisticsFunction({
  required GetCompanyGeneralStatisticsRequest getCompanyGeneralStatisticsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCompanyGeneralStatisticsRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.statistics}/GetCompanyGeneralStatistics",
    );
    AppSnackBar.showSuccess("Get Company General Statistics successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
