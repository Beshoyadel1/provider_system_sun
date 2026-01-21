import 'package:dio/dio.dart';
import '../../../../core/model/order/update_order_status_model/update_order_status_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateOrderStatusFunction({
  required UpdateOrderStatusRequest updateOrderStatusRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      updateOrderStatusRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.order}/UpdateOrderStatus",
    );
    AppSnackBar.showSuccess("Update Order Status successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}