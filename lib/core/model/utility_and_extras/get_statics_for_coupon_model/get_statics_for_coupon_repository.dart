import 'package:dio/dio.dart';
import '../../../../core/model/utility_and_extras/get_statics_for_coupon_model/get_statics_for_coupon_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getStaticsForCouponFunction({
  required GetStaticsForCouponRequest getStaticsForCouponRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getStaticsForCouponRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.coupon}/GetStaticsForCoupon",
    );
    AppSnackBar.showSuccess("Get Statics For Coupon successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}