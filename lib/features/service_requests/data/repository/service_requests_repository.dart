import 'package:dio/dio.dart';

import '../../../../core/api/dio_function/api_constants.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../model/service_request_model.dart';
import '../model/readable_api_text.dart';
import '../request/service_offer_request.dart';

abstract class ServiceRequestsRepository {
  Future<List<ServiceRequestModel>> getRequests({
    required int providerId,
  });

  Future<ServiceRequestModel> getDetails(int requestId);
  Future<int> createOffer(ServiceOfferRequest request);
  Future<void> updateOffer(ServiceOfferRequest request);
  Future<void> deleteOffer(int offerId);
  Future<String?> refuseRequest({
    required int providerId,
    required int requestId,
  });
}

class NetworkServiceRequestsRepository implements ServiceRequestsRepository {
  const NetworkServiceRequestsRepository();

  @override
  Future<List<ServiceRequestModel>> getRequests({
    required int providerId,
  }) async {
    final response = await _guard(() => Network.postDataWithBody(
          {'providerId': providerId},
          ApiLink.getServiceRequestsForProvider,
        ));
    final data = _successfulData(response.data);
    if (data is! List) throw Exception('Invalid service requests response');
    return data
        .whereType<Map>()
        .map((item) => ServiceRequestModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }

  @override
  Future<ServiceRequestModel> getDetails(int requestId) async {
    final response = await _guard(() => Network.postDataWithBodyAndParams(
          {},
          {'requestId': requestId},
          ApiLink.getServiceRequestDetails,
        ));
    final data = _successfulData(response.data);
    if (data is! Map) throw Exception('Invalid service request details');
    return ServiceRequestModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<int> createOffer(ServiceOfferRequest request) async {
    final response = await _guard(() => Network.postDataWithBody(
          request.toCreateJson(),
          ApiLink.createServiceOffer,
        ));
    final data = _successfulData(response.data);
    final id = data is num ? data.toInt() : int.tryParse('$data') ?? 0;
    if (id <= 0) throw Exception('Invalid created offer ID');
    return id;
  }

  @override
  Future<void> updateOffer(ServiceOfferRequest request) async {
    final response = await _guard(() => Network.postDataWithBody(
          request.toUpdateJson(),
          ApiLink.updateServiceOffer,
        ));
    _successfulData(response.data);
  }

  @override
  Future<void> deleteOffer(int offerId) async {
    final response = await _guard(() => Network.postDataWithBodyAndParams(
          {},
          {'offerId': offerId},
          ApiLink.deleteServiceOffer,
        ));
    _successfulData(response.data);
  }

  @override
  Future<String?> refuseRequest({
    required int providerId,
    required int requestId,
  }) async {
    final response = await _guard(() => Network.postDataWithBody(
          {'provid': providerId, 'servicerequestid': requestId},
          ApiLink.refuseServiceRequest,
        ));
    _successfulData(response.data);
    final message = response.data is Map ? response.data['message'] : null;
    return message == null ? null : readableApiText(message);
  }

  dynamic _successfulData(dynamic response) {
    if (response is! Map || response['success'] != true) {
      throw Exception(
        response is Map
            ? response['message']?.toString() ?? 'Something went wrong'
            : 'Invalid server response',
      );
    }
    return response['data'];
  }

  Future<Response<dynamic>> _guard(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      if ((response.statusCode ?? 500) >= 400) {
        final data = response.data;
        throw Exception(data is Map
            ? data['message'] ?? responseOfStatusCode(response.statusCode)
            : responseOfStatusCode(response.statusCode));
      }
      return response;
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        throw Exception(data['message']);
      }
      throw Exception(responseOfStatusCode(error.response?.statusCode));
    }
  }
}
