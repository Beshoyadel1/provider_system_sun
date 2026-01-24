import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/update_tax_model/update_tax_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateTaxFunction({required UpdateTaxRequest updateTaxRequest}) async {
  try {
    String jsonString = json.encode(updateTaxRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.tax}/UpdateTax",
    ).then((value) {
      AppSnackBar.showSuccess("Update Tax successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}