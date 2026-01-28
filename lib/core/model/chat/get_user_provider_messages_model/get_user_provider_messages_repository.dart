import 'package:dio/dio.dart';
import '../../../../core/model/chat/get_user_provider_messages_model/get_user_provider_messages_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getUserProviderMessagesFunction({
  required GetUserProviderMessagesRequest getUserProviderMessagesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getUserProviderMessagesRequest.toJson(), // params
      ApiLink.getUserProviderMessages,
    );
    AppSnackBar.showSuccess("Get User Provider Messages successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}