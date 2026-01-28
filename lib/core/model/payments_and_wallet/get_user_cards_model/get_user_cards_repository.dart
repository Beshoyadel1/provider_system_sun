import 'package:dio/dio.dart';
import '../../../../core/model/payments_and_wallet/get_user_cards_model/get_user_cards_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getUserCardsFunction({
  required GetUserCardsRequest getUserCardsRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getUserCardsRequest.toJson(),
      ApiLink.getUserCards,
    );
    AppSnackBar.showSuccess("Get User Cards successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}