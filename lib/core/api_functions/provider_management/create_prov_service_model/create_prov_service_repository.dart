import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import '../../../../core/api/dio_function/apiRoutes.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/language/language_constant.dart';

Future<void> createProvServiceFunction({required CreateProvServiceRequest createProvServiceRequest}) async {
  try {
    String jsonString = json.encode(createProvServiceRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.createProvService,
    ).then((value) {
      AppSnackBar.showSuccess(AppLanguageKeys.createProvServiceSuccess);
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}