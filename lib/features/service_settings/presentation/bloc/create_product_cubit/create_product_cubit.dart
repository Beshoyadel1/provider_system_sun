import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/create_product_datasource/create_product_repository.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_product_model/create_product_request.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/update_product_datasource/update_product_repository.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_product_cubit/create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final int? productId;

  CreateProductCubit({this.productId})
      : super(CreateProductInitial());

  Future<int> _getProviderId() async {
    final user = await AuthLocalStorage.getUser();
    return user?.userid ?? 0;
  }

  Future<void> createProduct({
    required CreateProductRequest request,
  }) async {
    emit(CreateProductLoading());

    try {
      final providerId = await _getProviderId();

      final updatedSizes = request.sizes?.map((size) {
        return size.copyWith(provId: providerId);
      }).toList();

      final updatedRequest = request.copyWith(
        provId: providerId,
        sizes: updatedSizes,
      );

      await createProductApi(request: updatedRequest);

      emit(CreateProductSuccess());
    } catch (e) {
      emit(CreateProductError(e.toString()));
    }
  }

  Future<void> updateProduct({
    required CreateProductRequest request,
  }) async {
    emit(CreateProductLoading());

    try {
      if (productId == null) {
        throw Exception("Product ID is required for update");
      }

      final providerId = await _getProviderId();

      final updatedSizes = request.sizes?.map((size) {
        return size.copyWith(provId: providerId);
      }).toList();

      final updatedRequest = request.copyWith(
        provId: providerId,
        sizes: updatedSizes,
      );

      final json = updatedRequest.toJson();
      json["id"] = productId;

      await updateProductApi(body: json);

      emit(CreateProductSuccess());
    } catch (e) {
      emit(CreateProductError(e.toString()));
    }
  }
}