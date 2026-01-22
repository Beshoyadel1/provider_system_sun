import 'package:dio/dio.dart';
import '../../../../core/model/rates/get_provider_details_rates_model/get_provider_details_rates_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderDetailsRatesFunction({
  required GetProviderDetailsRatesRequest getProviderDetailsRatesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderDetailsRatesRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.rate}/GetProviderDetailsRates",
    );
    AppSnackBar.showSuccess("Get Provider Details Rates successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}