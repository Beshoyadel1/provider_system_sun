import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_provider_orders_sales_model/get_provider_orders_sales_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderOrdersSalesFunction({
  required GetProviderOrdersSalesRequest getProviderOrdersSalesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderOrdersSalesRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.statistics}/GetProviderOrdersSales",
    );
    AppSnackBar.showSuccess("Get Provider Orders Sales successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
