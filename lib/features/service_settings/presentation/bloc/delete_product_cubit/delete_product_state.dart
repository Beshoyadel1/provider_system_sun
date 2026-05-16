part of 'delete_product_cubit.dart';

abstract class DeleteProductState {}

class DeleteProductInitial extends DeleteProductState {}

class DeleteProductLoading extends DeleteProductState {}

class DeleteProductSuccess extends DeleteProductState {}

class DeleteProductError extends DeleteProductState {
  final String error;
  DeleteProductError(this.error);
}