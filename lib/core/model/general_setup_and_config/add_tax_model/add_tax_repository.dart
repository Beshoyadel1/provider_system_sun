import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/general_setup_and_config/add_tax_model/add_tax_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> addTaxFunction({required AddTaxRequest addTaxRequest}) async {
  try {
    String jsonString = json.encode(addTaxRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.tax}/AddTax",
    ).then((value) {
      AppSnackBar.showSuccess("Add Tax successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}