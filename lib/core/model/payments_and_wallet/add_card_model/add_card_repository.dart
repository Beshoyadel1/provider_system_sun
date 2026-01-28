import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/payments_and_wallet/add_card_model/add_card_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> addCardFunction({required AddCardRequest addCardRequest}) async {
  try {
    String jsonString = json.encode(addCardRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
        ApiLink.addCard
    ).then((value) {
      AppSnackBar.showSuccess("Add Card successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}