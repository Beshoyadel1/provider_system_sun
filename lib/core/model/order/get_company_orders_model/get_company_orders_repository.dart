import 'package:dio/dio.dart';
import '../../../../core/model/order/get_company_orders_model/get_company_orders_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCompanyOrdersFunction({
  required GetCompanyOrdersRequest getCompanyOrdersRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCompanyOrdersRequest.toJson(), // params
      ApiLink.getCompanyOrders,
    );
    AppSnackBar.showSuccess("Get Company Orders successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}