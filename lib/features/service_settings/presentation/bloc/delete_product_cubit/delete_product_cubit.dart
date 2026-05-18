import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/delete_product_datasource/delete_product_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/delete_product_request/delete_product_request.dart';
part 'delete_product_state.dart';



class DeleteProductCubit extends Cubit<DeleteProductState> {
  DeleteProductCubit() : super(DeleteProductInitial());

  Future<void> deleteProduct(int productId) async {
    emit(DeleteProductLoading());

    try {
      await deleteProductFunction(
        deleteProductRequest: DeleteProductRequest(
          productId: productId,
        ),
      );

      emit(DeleteProductSuccess());
    } catch (e) {
      emit(DeleteProductError(e.toString()));
    }
  }
}