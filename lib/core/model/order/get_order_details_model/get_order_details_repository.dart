import 'package:dio/dio.dart';
import '../../../../core/model/order/get_order_details_model/get_order_details_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getOrderDetailsFunction({
  required GetOrderDetailsRequest getOrderDetailsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getOrderDetailsRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.order}/GetOrderDetails",
    );
    AppSnackBar.showSuccess("Get Order Details successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}