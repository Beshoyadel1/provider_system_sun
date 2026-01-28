import 'package:dio/dio.dart';
import '../../../../core/model/order/update_order_offer_status_model/update_order_offer_status_request.dart';
import '../../../../core/model/order/get_order_details_model/get_order_details_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateOrderOfferStatusFunction({
  required UpdateOrderOfferStatusRequest updateOrderOfferStatusRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      updateOrderOfferStatusRequest.toJson(), // params
      ApiLink.updateOrderOfferStatus,
    );
    AppSnackBar.showSuccess("Update Order Offer Status successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}