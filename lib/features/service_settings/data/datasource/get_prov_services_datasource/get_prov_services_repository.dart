import 'package:dio/dio.dart';
import 'package:sun_web_system/features/service_settings/data/request/get_prov_services_request/get_prov_services_request.dart';
import 'package:sun_web_system/features/service_settings/data/response/get_prov_services_response/get_prov_services_response.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<List<GetProvServicesResponse>> getProvServicesFunction({
  required GetProvServicesRequest getProvServicesRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      getProvServicesRequest.toJson(),
      ApiLink.getProvServices,
    );

    final body = response.data;
    if (body is! Map || body['success'] != true) {
      throw FormatException(body is Map
          ? body['message']?.toString() ?? 'Unable to load services'
          : 'Invalid services response');
    }
    final res = body['data'];

    if (res == null) {
      return [];
    }

    if (res is List) {
      if (res.isEmpty) {
        return [];
      }

      return res
          .map((e) =>
              GetProvServicesResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (res is Map<String, dynamic>) {
      if (res.isEmpty) {
        return [];
      }

      return [
        GetProvServicesResponse.fromJson(res),
      ];
    }

    return [];
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
