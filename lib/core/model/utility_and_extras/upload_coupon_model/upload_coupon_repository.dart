import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/utility_and_extras/upload_coupon_model/upload_coupon_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> uploadCouponFunction({required UploadCouponRequest uploadCouponRequest}) async {
  try {
    String jsonString = json.encode(uploadCouponRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.coupon}/UploadCoupon",
    ).then((value) {
      AppSnackBar.showSuccess("Upload Coupon successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}

