import 'package:dio/dio.dart';
import '../../../../core/model/chat/make_chat_viewed_model/make_chat_viewed_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> makeChatViewedFunction({
  required MakeChatViewedRequest makeChatViewedRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      makeChatViewedRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.chat}/MakeChatViewed",
    );
    AppSnackBar.showSuccess("Make Chat Viewed successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}