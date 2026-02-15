import 'package:dio/dio.dart';
import '../../../../core/api_functions/statistics/get_provider_petrol_sales_chart_model/get_provider_petrol_sales_chart_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<void> getProviderPetrolSalesChartFunction({
  required GetProviderPetrolSalesChartRequest getProviderPetrolSalesChartRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderPetrolSalesChartRequest.toJson(), // params
        ApiLink.getProviderPetrolSalesChart
    );
    AppSnackBar.showSuccess(AppLanguageKeys.getProviderPetrolSalesChartSuccessfully);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
