import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_provider_petrol_sales_chart_model/get_provider_petrol_sales_chart_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderPetrolSalesChartFunction({
  required GetProviderPetrolSalesChartRequest getProviderPetrolSalesChartRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderPetrolSalesChartRequest.toJson(), // params
        ApiLink.getProviderPetrolSalesChart
    );
    AppSnackBar.showSuccess("Get Provider Petrol Sales Chart successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
