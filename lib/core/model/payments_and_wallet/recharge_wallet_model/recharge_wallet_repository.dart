import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/payments_and_wallet/recharge_wallet_model/recharge_wallet_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> rechargeWalletFunction({required RechargeWalletRequest rechargeWalletRequest}) async {
  try {
    String jsonString = json.encode(rechargeWalletRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.payment}/RechargeWallet",
    ).then((value) {
      AppSnackBar.showSuccess("Recharge Wallet successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}