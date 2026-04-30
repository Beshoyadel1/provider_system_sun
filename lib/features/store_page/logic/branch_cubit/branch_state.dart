import 'package:sun_web_system/core/api_functions/branch/get_provider_branches_model/provider_branch_model.dart';

abstract class BranchState {}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchSuccess extends BranchState {
  final List<ProviderBranchModel> branches;
  final bool isAdding;
  final int? editingIndex;
  final bool fromSubmit;

  BranchSuccess({
    required this.branches,
    this.isAdding = false,
    this.editingIndex,
    this.fromSubmit = false,
  });

  BranchSuccess copyWith({
    List<ProviderBranchModel>? branches,
    bool? isAdding,
    int? editingIndex,
    bool? fromSubmit,
  }) {
    return BranchSuccess(
      branches: branches ?? this.branches,
      isAdding: isAdding ?? this.isAdding,
      editingIndex: editingIndex,
      fromSubmit: fromSubmit ?? false,
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