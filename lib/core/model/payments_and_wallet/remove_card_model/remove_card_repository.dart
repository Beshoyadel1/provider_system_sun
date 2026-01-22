import 'package:dio/dio.dart';
import '../../../../core/model/payments_and_wallet/remove_card_model/remove_card_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> removeCardFunction({
  required RemoveCardRequest removeCardRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      removeCardRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.paymentCard}/RemoveCard",
    );
    AppSnackBar.showSuccess("Remove Card successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}