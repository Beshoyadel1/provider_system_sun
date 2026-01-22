import 'package:dio/dio.dart';
import '../../../../core/model/payments_and_wallet/set_default_card_model/set_default_card_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> setDefaultCardFunction({
  required SetDefaultCardRequest setDefaultCardRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      setDefaultCardRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.paymentCard}/SetDefaultCard",
    );
    AppSnackBar.showSuccess("Set Default Card successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}