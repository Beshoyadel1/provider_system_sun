import 'package:dio/dio.dart';
import '../../../../core/model/utility_and_extras/get_coupon_by_code_model/get_coupon_by_code_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getCouponByCodeFunction({
  required GetCouponByCodeRequest getCouponByCodeRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getCouponByCodeRequest.toJson(), // params
      ApiLink.getCouponByCode,
    );
    AppSnackBar.showSuccess("Get Coupon By Code successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}