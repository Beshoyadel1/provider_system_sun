import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/api_functions/provider_management/create_service_package_model/create_service_package_request.dart';
import '../../../../core/api/dio_function/apiRoutes.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<void> createServicePackageFunction({required CreateServicePackageRequest createServicePackageRequest}) async {
  try {
    String jsonString = json.encode(createServicePackageRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
        ApiLink.createServicePackage
    ).then((value) {
      AppSnackBar.showSuccess(AppLanguageKeys.createServicePackageSuccess);
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}