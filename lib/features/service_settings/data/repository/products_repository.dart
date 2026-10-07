import 'package:dio/dio.dart';
import '../../../../core/api/dio_function/api_constants.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/constants.dart';
import '../model/get_products_by_category_model/product_model_get_products_by_category.dart';
import '../request/get_provider_products_request.dart';
import '../request/create_product_request/create_product_request.dart';

abstract class ProductsRepository {
  Future<List<ProductModelGetProductsByCategory>> getProviderProducts(
      GetProviderProductsRequest request);
  Future<ProductModelGetProductsByCategory> getProduct(int productId);
}

abstract class ProductsWriter {
  Future<int> createProduct(CreateProductRequest request);
  Future<void> updateProduct(int productId, CreateProductRequest request);
  Future<void> deleteProduct(int productId);
}

class ProductApiException implements Exception {
  final String message;
  const ProductApiException(this.message);
  @override
  String toString() => message;
}

class NetworkProductsRepository implements ProductsRepository, ProductsWriter {
  final Dio? client;
  const NetworkProductsRepository({this.client});

  Future<dynamic> _post(String url, Map<String, dynamic> query,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await (client ?? Network.dio).post(
        url,
        data: data ?? <String, dynamic>{},
        queryParameters: query,
        options: Options(headers: myHeaders),
      );
      final body = response.data;
      if (body is! Map ||
          body['success'] != true ||
          response.statusCode == null ||
          response.statusCode! >= 400) {
        throw ProductApiException(_message(body));
      }
      return body['data'];
    } on DioException catch (error) {
      throw ProductApiException(_message(error.response?.data));
    }
  }

  String _message(dynamic body) {
    if (body is Map && body['message'] is String) {
      final message = (body['message'] as String).trim();
      if (message.isNotEmpty) return message;
    }
    return Network.languageCode == 'ar'
        ? 'تعذر إتمام عملية المنتج. حاول مرة أخرى.'
        : 'Unable to complete the product operation. Please try again.';
  }

  @override
  Future<List<ProductModelGetProductsByCategory>> getProviderProducts(
      GetProviderProductsRequest request) async {
    final data = await _post(ApiLink.getProviderProducts, request.toQuery());
    if (data is! List) throw ProductApiException(_message(null));
    return data.map((item) {
      if (item is! Map) throw ProductApiException(_message(null));
      return ProductModelGetProductsByCategory.fromJson(
          Map<String, dynamic>.from(item));
    }).toList();
  }

  @override
  Future<ProductModelGetProductsByCategory> getProduct(int productId) async {
    final data = await _post(ApiLink.getProduct, {'productId': productId});
    if (data is! Map) throw ProductApiException(_message(null));
    final product = ProductModelGetProductsByCategory.fromJson(
        Map<String, dynamic>.from(data));
    if (product.id != productId) throw ProductApiException(_message(null));
    return product;
  }

  @override
  Future<int> createProduct(CreateProductRequest request) async {
    final data = await _post(ApiLink.createProduct, {}, data: request.toJson());
    if (data is! int || data <= 0) throw ProductApiException(_message(null));
    return data;
  }

  @override
  Future<void> updateProduct(
      int productId, CreateProductRequest request) async {
    await _post(ApiLink.updateProduct, {},
        data: {...request.toJson(), 'id': productId});
  }

  @override
  Future<void> deleteProduct(int productId) async {
    await _post(ApiLink.deleteProduct, {'productId': productId});
  }
}
