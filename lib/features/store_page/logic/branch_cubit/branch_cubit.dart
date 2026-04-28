import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/branch/add_branch_model/add_branch_repository.dart';
import 'package:sun_web_system/core/api_functions/branch/add_branch_model/add_branch_request.dart';
import 'package:sun_web_system/core/api_functions/branch/get_provider_branches_model/get_provider_branches_repository.dart';
import 'package:sun_web_system/core/api_functions/branch/get_provider_branches_model/provider_branch_model.dart';
import 'package:sun_web_system/core/api_functions/branch/update_branch_model/update_branch_repository.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'branch_state.dart';
import '../../../../core/api_functions/branch/get_provider_branches_model/get_provider_branches_request.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit() : super(BranchInitial());

  List<ProviderBranchModel> branches = [];
  int? myUserId;

  Future<void> _initUser() async {
    if (myUserId != null) return;
    final user = await AuthLocalStorage.getUser();
    myUserId = user!.userid!;
  }

  Future<void> getProviderBranches() async {
    emit(BranchLoading());

    try {
      await _initUser();

      branches = await getProviderBranchesFunction(
        getProviderBranchesRequest:
        GetProviderBranchesRequest(providerId: myUserId!),
      );

      emit(BranchSuccess(branches: branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  void goToAdd() {
    final current = state as BranchSuccess;
    emit(current.copyWith(isAdding: true, editingIndex: null));
  }

  void edit(int index) {
    final current = state as BranchSuccess;
    emit(current.copyWith(isAdding: true, editingIndex: index));
  }

  void back() {
    final current = state as BranchSuccess;
    emit(current.copyWith(isAdding: false, editingIndex: null));
  }

  Future<void> addBranch(AddBranchRequest request) async {
    try {
      await _initUser();

      final body = request.toJson(myUserId!);
      final response = await addBranchFunction(body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final newBranch = ProviderBranchModel.fromJson(response.data);
          branches.add(newBranch);
        }

        emit(BranchSuccess(branches: List.from(branches)));
      }
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> updateBranch(int index, AddBranchRequest request) async {
    try {
      await _initUser();

      final body = request.toJson(myUserId!);
      final response = await updateBranchFunction(body: body);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          branches[index] =
              ProviderBranchModel.fromJson(response.data);
        }

        emit(BranchSuccess(branches: List.from(branches)));
      }
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }
}