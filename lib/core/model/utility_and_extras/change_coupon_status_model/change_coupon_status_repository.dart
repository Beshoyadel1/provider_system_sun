import 'package:dio/dio.dart';
import '../../../../core/model/utility_and_extras/change_coupon_status_model/change_coupon_status_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> changeCouponStatusFunction({
  required ChangeCouponStatusRequest changeCouponStatusRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      changeCouponStatusRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.coupon}/ChangeCouponStatus",
    );
    AppSnackBar.showSuccess("Change Coupon Status successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}