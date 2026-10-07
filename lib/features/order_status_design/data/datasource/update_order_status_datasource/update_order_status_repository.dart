import '../../request/update_order_status_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import 'package:dio/dio.dart';

Future<bool> updateOrderStatusFunction({
  required UpdateOrderStatusRequest updateOrderStatusRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      null,
      updateOrderStatusRequest.toJson(),
      ApiLink.updateOrderStatus,
    );

    final data = response.data;
    if ((response.statusCode ?? 500) >= 400 ||
        data is! Map ||
        data['success'] != true) {
      throw Exception(data is Map
          ? data['message'] ?? 'Failed to update order status'
          : responseOfStatusCode(response.statusCode));
    }
    return true;
  } on DioException catch (e) {
    final data = e.response?.data;
    throw Exception(data is Map
        ? data['message'] ?? responseOfStatusCode(e.response?.statusCode)
        : responseOfStatusCode(e.response?.statusCode));
  }
}
