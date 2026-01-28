import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/update_expected_petrol_spend_model/update_expected_petrol_spend_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> updateExpectedPetrolSpendFunction({required UpdateExpectedPetrolSpendRequest updateExpectedPetrolSpendRequestRequest}) async {
  try {
    String jsonString = json.encode(updateExpectedPetrolSpendRequestRequest.toJson());

    await Network.putDataWithBody(
      jsonString,
      ApiLink.updateExpectedPetrolSpend,
    ).then((value) {
      AppSnackBar.showSuccess("Update Expected Petrol Spend successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}