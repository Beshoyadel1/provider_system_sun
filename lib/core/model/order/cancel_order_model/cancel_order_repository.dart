import 'package:dio/dio.dart';
import '../../../../core/model/order/cancel_order_model/cancel_order_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> cancelOrderFunction({
  required CancelOrderRequest cancelOrderRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      cancelOrderRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.order}/CancelOrder",
    );
    AppSnackBar.showSuccess("Cancel Order successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}