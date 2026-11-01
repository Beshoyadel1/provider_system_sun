import 'package:dio/dio.dart';
import 'api_json.dart';

/// Business success is separate from a transport response with HTTP 200.
class ApiResult {
  static Map<String, dynamic> requireSuccess(Response response) {
    final data = response.data;
    final body = data is Map ? ApiJson.object(data) : null;
    if ((response.statusCode ?? 500) >= 400 ||
        body == null ||
        body['success'] != true ||
        body['status'] == false) {
      throw Exception(
          body?['message']?.toString() ?? 'Could not complete the request');
    }
    return body;
  }
}
