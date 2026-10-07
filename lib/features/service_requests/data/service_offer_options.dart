import '../../../core/api/dio_function/api_constants.dart';
import '../../../core/api/dio_function/dio_controller.dart';
import '../../auth_page/data/model/create_user_model/create_user_request.dart';
import '../../service_settings/data/datasource/get_prov_services_datasource/get_prov_services_repository.dart';
import '../../service_settings/data/request/get_prov_services_request/get_prov_services_request.dart';
import '../../service_settings/data/response/get_prov_services_response/get_prov_services_response.dart';

/// Reopening an offer form shares its existing option fetches for five minutes.
class ServiceOfferOptions {
  ServiceOfferOptions._();
  static final instance = ServiceOfferOptions._();
  final _cache = <String, ({DateTime expires, Future<List<dynamic>> result})>{};

  Future<List<T>> _load<T>(
      String key, Future<List<T>> Function() loader) async {
    var entry = _cache[key];
    if (entry == null || entry.expires.isBefore(DateTime.now())) {
      entry = (
        expires: DateTime.now().add(const Duration(minutes: 5)),
        result: loader()
      );
      _cache[key] = entry;
    }
    try {
      return (await entry.result).cast<T>();
    } catch (_) {
      if (identical(_cache[key]?.result, entry.result)) _cache.remove(key);
      rethrow;
    }
  }

  Future<List<GetProvServicesResponse>> services(
          int providerId, int serviceId) =>
      _load(
          'service:$providerId:$serviceId',
          () => getProvServicesFunction(
              getProvServicesRequest: GetProvServicesRequest(
                  providerId: providerId, serviceId: serviceId)));
  Future<List<CreateUserRequest>> employees(
      int providerId, int branchId, List<int> serviceIds) {
    final ids = serviceIds.toSet().toList()..sort();
    return _load('employees:$providerId:$branchId:${ids.join(',')}', () async {
      final response = await Network.postDataWithBody({
        'providerId': providerId,
        'serviceIds': ids,
        'branchId': branchId,
      }, ApiLink.getProviderEmployeesByServices);
      final body = response.data;
      if (body is! Map || body['success'] != true) {
        throw Exception(body is Map
            ? body['message'] ?? 'Could not load employees'
            : 'Invalid employees response');
      }
      final data = body['data'];
      if (data is! List) throw Exception('Invalid employees response');
      return data
          .map((item) => CreateUserRequest.fromJson(
              Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
    });
  }

  void reset() => _cache.clear();
}
