import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/banner/upload_banners_model/upload_banners_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> uploadBannersFunction({required UploadBannersRequest uploadBannersRequest}) async {
  try {
    String jsonString = json.encode(uploadBannersRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.uploadBanners,
    ).then((value) {
      AppSnackBar.showSuccess("Upload Banners successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}