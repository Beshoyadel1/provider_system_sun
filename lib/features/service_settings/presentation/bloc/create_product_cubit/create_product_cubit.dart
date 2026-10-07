import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/service_settings/data/repository/products_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/create_product_request/create_product_request.dart';
import 'create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final int? productId;
  final ProductsWriter writer;
  final Future<int> Function() providerIdLoader;

  CreateProductCubit(
      {this.productId,
      this.writer = const NetworkProductsRepository(),
      Future<int> Function()? providerIdLoader})
      : providerIdLoader = providerIdLoader ?? _getProviderId,
        super(CreateProductInitial());

  static Future<int> _getProviderId() async =>
      (await AuthLocalStorage.getUser())?.userid ?? 0;

  Future<void> createProduct({required CreateProductRequest request}) =>
      _save(request, update: false);

  Future<void> updateProduct({required CreateProductRequest request}) =>
      _save(request, update: true);

  Future<void> _save(CreateProductRequest request,
      {required bool update}) async {
    if (isClosed || state is CreateProductLoading) return;
    emit(CreateProductLoading());
    try {
      final providerId = await providerIdLoader();
      if (providerId <= 0) {
        throw const ProductApiException('Provider ID is required');
      }
      final body = request.copyWith(
          provId: providerId,
          sizes: request.sizes
              ?.map((size) => size.copyWith(provId: providerId))
              .toList());
      final int savedId;
      if (update) {
        if (productId == null || productId! <= 0) {
          throw const ProductApiException('Product ID is required');
        }
        await writer.updateProduct(productId!, body);
        savedId = productId!;
      } else {
        savedId = await writer.createProduct(body);
      }
      if (!isClosed) emit(CreateProductSuccess(productId: savedId));
    } catch (error) {
      if (!isClosed) emit(CreateProductError(error.toString()));
    }
  }
}
