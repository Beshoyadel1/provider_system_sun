import 'package:dio/dio.dart';
import '../../../../core/api_functions/order/get_provider_orders_model/get_provider_orders_response.dart';
import '../../../../core/api_functions/order/get_provider_orders_model/get_provider_orders_request.dart';
import '../../../../core/api/dio_function/apiRoutes.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<GetProviderOrdersResponse> getProviderOrdersFunction({
  required GetProviderOrdersRequest getProviderOrdersRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      getProviderOrdersRequest.toJson(),
      ApiLink.getProviderOrders,
    );

    final result = GetProviderOrdersResponse.fromJson(response.data);

    AppSnackBar.showSuccess(
      AppLanguageKeys.getProviderOrdersSuccessfully,
    );

    return result;
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    rethrow;
  }
}