import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/create_service_package_model/create_service_package_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createServicePackageFunction({required CreateServicePackageRequest createServicePackageRequest}) async {
  try {
    String jsonString = json.encode(createServicePackageRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
        ApiLink.createServicePackage
    ).then((value) {
      AppSnackBar.showSuccess("Create Service Package successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}