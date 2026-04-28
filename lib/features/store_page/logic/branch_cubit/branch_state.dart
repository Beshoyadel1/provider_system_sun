import 'package:sun_web_system/core/api_functions/branch/get_provider_branches_model/provider_branch_model.dart';

abstract class BranchState {}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchSuccess extends BranchState {
  final List<ProviderBranchModel> branches;
  final bool isAdding;
  final int? editingIndex;

  BranchSuccess({
    required this.branches,
    this.isAdding = false,
    this.editingIndex,
  });

  BranchSuccess copyWith({
    List<ProviderBranchModel>? branches,
    bool? isAdding,
    int? editingIndex,
  }) {
    return BranchSuccess(
      branches: branches ?? this.branches,
      isAdding: isAdding ?? this.isAdding,
      editingIndex: editingIndex,
    );
  }
}

class BranchError extends BranchState {
  final String message;
  BranchError(this.message);
}

class BranchOperationSuccess extends BranchState {
  final String message;
  BranchOperationSuccess(this.message);
}