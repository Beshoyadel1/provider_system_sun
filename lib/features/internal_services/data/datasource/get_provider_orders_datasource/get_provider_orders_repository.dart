import 'package:dio/dio.dart';
import '../../../../../../../features/internal_services/data/request/get_provider_orders_request/get_provider_orders_request.dart';
import '../../../../../../../features/internal_services/data/response/get_provider_orders_response/get_provider_orders_response.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<GetProviderOrdersResponse> getProviderOrdersFunction({
  required GetProviderOrdersRequest getProviderOrdersRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      getProviderOrdersRequest.toJson(),
      ApiLink.getProviderOrders,
    );

    if ((response.statusCode ?? 500) >= 400) {
      final data = response.data;
      throw Exception(data is Map
          ? data['message'] ?? responseOfStatusCode(response.statusCode)
          : responseOfStatusCode(response.statusCode));
    }
    if (response.data is! Map<String, dynamic>) {
      throw const FormatException('Invalid provider orders response');
    }
    final result = GetProviderOrdersResponse.fromJson(response.data);

    return result;
  } on DioException catch (e) {
    final data = e.response?.data;
    throw Exception(data is Map
        ? data['message'] ?? responseOfStatusCode(e.response?.statusCode)
        : responseOfStatusCode(e.response?.statusCode));
  }
}
