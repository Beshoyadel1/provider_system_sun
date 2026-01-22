import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/payments_and_wallet/create_payment_model/create_payment_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> createPaymentFunction({required CreatePaymentRequest createPaymentRequest}) async {
  try {
    String jsonString = json.encode(createPaymentRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.payment}/CreatePayment",
    ).then((value) {
      AppSnackBar.showSuccess("Create Payment successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}