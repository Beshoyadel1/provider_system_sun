import 'package:dio/dio.dart';
import '../../../../core/model/payments_and_wallet/get_wallet_balance_model/get_wallet_balance_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getWalletBalanceFunction({
  required GetWalletBalanceRequest getWalletBalanceRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getWalletBalanceRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.payment}/GetWalletBalance",
    );
    AppSnackBar.showSuccess("Get Wallet Balance successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}