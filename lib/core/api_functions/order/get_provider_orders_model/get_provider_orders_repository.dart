import 'package:dio/dio.dart';
import '../../../../core/api_functions/order/get_provider_orders_model/get_provider_orders_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<void> getProviderOrdersFunction({
  required GetProviderOrdersRequest getProviderOrdersRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderOrdersRequest.toJson(), // params
      ApiLink.getProviderOrders,
    );
    AppSnackBar.showSuccess(AppLanguageKeys.getProviderOrdersSuccessfully);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}