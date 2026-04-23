import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import '../../../../core/api_functions/product/create_product_model/create_product_repository.dart';
import '../../../../core/api_functions/product/create_product_model/create_product_request.dart';
import '../../../../features/service_settings/logic/create_product_cubit/create_product_state.dart';



class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit() : super(CreateProductInitial());

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
}