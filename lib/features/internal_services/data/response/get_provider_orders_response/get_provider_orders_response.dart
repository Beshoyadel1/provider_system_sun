import '../../../../../../../features/internal_services/data/model/get_provider_orders_model/order_model.dart';

class GetProviderOrdersResponse {
  final List<OrderModel> data;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  GetProviderOrdersResponse({
    required this.data,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetProviderOrdersResponse.fromJson(Map<String, dynamic> json) {
    if (json['success'] != true) {
      throw Exception(json['message'] ?? 'Failed to load orders');
    }
    final responseData = json['data'];
    if (responseData is! Map || responseData['data'] is! List) {
      throw const FormatException('Invalid provider orders response');
    }

    return GetProviderOrdersResponse(
      data: (responseData['data'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pageCount: responseData['pageCount'] ?? 0,
      totalCount: responseData['totalCount'] ?? 0,
      currentPage: responseData['currentPage'] ?? 0,
    );
  }
}
