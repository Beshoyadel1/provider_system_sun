import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/create_expected_petrol_spend_model/create_expected_petrol_spend_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createExpectedPetrolSpendFunction({required CreateExpectedPetrolSpendRequest createExpectedPetrolSpendRequest}) async {
  try {
    String jsonString = json.encode(createExpectedPetrolSpendRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
        ApiLink.createExpectedPetrolSpend
    ).then((value) {
      AppSnackBar.showSuccess("Create Expected Petrol Spend successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}