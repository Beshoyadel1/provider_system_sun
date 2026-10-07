import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/service_settings/data/repository/products_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/get_provider_products_request.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_products_by_category_cubit/get_products_by_category_state.dart';

class GetProductsByCategoryCubit extends Cubit<GetProductsByCategoryState> {
  GetProductsByCategoryCubit({
    ProductsRepository? repository,
    Future<int> Function()? providerIdLoader,
  })  : _repository = repository ?? const NetworkProductsRepository(),
        _providerIdLoader = providerIdLoader ?? _loadProviderId,
        super(GetProductsByCategoryInitial());

  final ProductsRepository _repository;
  final Future<int> Function() _providerIdLoader;
  int _requestVersion = 0;

  static Future<int> _loadProviderId() async {
    final user = await AuthLocalStorage.getUser();
    final id = user?.userid;
    if (id == null || id <= 0) {
      throw const ProductApiException('User not found');
    }
    return id;
  }

  List<ProductModelGetProductsByCategory> products = [];

  Future<void> getProductsByCategory({
    required int categoryId,
    int? branchId,
  }) async {
    final version = ++_requestVersion;
    products = [];
    emit(GetProductsByCategoryLoading());
    try {
      final providerId = await _providerIdLoader();
      if (isClosed || version != _requestVersion) return;
      final result = await _repository.getProviderProducts(
        GetProviderProductsRequest(
          providerId: providerId,
          categoryId: categoryId,
          branchId: branchId,
        ),
      );
      if (isClosed || version != _requestVersion) return;
      products = result;
      emit(GetProductsByCategorySuccess());
    } catch (error) {
      if (!isClosed && version == _requestVersion) {
        emit(GetProductsByCategoryError(error.toString()));
      }
    }
  }
}
