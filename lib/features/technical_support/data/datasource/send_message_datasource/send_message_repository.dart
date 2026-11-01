import 'dart:convert';
import '../../../../../core/api/api_result.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../request/send_message_request/send_message_request.dart';

Future<void> sendMessageFunction({required SendMessageRequest sendMessageRequest}) async {
  final response = await Network.postDataWithBody(
    jsonEncode(sendMessageRequest.toJson()), ApiLink.sendMessage);
  ApiResult.requireSuccess(response);
}
