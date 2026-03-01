import 'package:dio/dio.dart';
import '../../../../core/api_functions/order/update_order_status_model/update_order_status_request.dart';
import '../../../../core/api/dio_function/apiRoutes.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<void> updateOrderStatusFunction({
  required UpdateOrderStatusRequest updateOrderStatusRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      updateOrderStatusRequest.toJson(), // params
        ApiLink.updateOrderStatus
    );
    AppSnackBar.showSuccess(AppLanguageKeys.updateOrderStatusSuccessfully);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}