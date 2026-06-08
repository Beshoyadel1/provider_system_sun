import 'package:dio/dio.dart';
import '../../response/get_provider_details_rates_response/get_provider_details_rates_response.dart';
import '../../request/get_provider_details_rates_request/get_provider_details_rates_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<ProviderDetailsRatesResponse> getProviderDetailsRatesFunction({
  required GetProviderDetailsRatesRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderDetailsRates,
    );

    return ProviderDetailsRatesResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw responseOfStatusCode(e.response?.statusCode);
  }
}