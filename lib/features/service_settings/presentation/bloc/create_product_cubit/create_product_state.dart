abstract class CreateProductState {}

class CreateProductInitial extends CreateProductState {}

class CreateProductLoading extends CreateProductState {}

class CreateProductSuccess extends CreateProductState {
  final int? productId;
  CreateProductSuccess({this.productId});
}

class CreateProductError extends CreateProductState {
  final String error;
  CreateProductError(this.error);
}

class UpdateProductLoading extends CreateProductState {}

class UpdateProductSuccess extends CreateProductState {}
