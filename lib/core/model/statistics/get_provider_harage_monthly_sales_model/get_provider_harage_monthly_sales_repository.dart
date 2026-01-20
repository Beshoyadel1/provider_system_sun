import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_provider_harage_monthly_sales_model/get_provider_harage_monthly_sales_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderHarageMonthlySalesFunction({
  required GetProviderHarageMonthlySalesRequest getProviderHarageMonthlySalesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderHarageMonthlySalesRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.statistics}/GetProviderHarageMonthlySales",
    );
    AppSnackBar.showSuccess("Get Provider Harage Monthly Sales successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}