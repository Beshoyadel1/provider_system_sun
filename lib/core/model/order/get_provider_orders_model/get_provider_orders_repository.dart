import 'package:dio/dio.dart';
import '../../../../core/model/order/get_provider_orders_model/get_provider_orders_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderOrdersFunction({
  required GetProviderOrdersRequest getProviderOrdersRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderOrdersRequest.toJson(), // params
      ApiLink.getProviderOrders,
    );
    AppSnackBar.showSuccess("Get Provider Orders successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}