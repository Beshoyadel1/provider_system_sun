import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api_functions/product/delete_product_model/delete_product_request.dart';
import '../../../../core/api_functions/product/delete_product_model/delete_product_repository.dart';

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