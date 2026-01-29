import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_provider_harage_sales_chart_model/get_provider_harage_sales_chart_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<void> getProviderHarageSalesChartFunction({
  required GetProviderHarageSalesChartRequest getProviderHarageSalesChartRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderHarageSalesChartRequest.toJson(), // params
        ApiLink.getProviderHarageSalesChart
    );
    AppSnackBar.showSuccess(AppLanguageKeys.getProviderHarageSalesChartSuccessfully);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}