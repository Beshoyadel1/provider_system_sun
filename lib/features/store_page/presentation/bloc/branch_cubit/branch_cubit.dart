import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/store_page/data/datasource/add_branch_datasource/add_branch_repository.dart';
import 'package:sun_web_system/features/store_page/data/request/add_branch_request/add_branch_request.dart';
import 'package:sun_web_system/features/store_page/data/datasource/get_provider_branches_datasource/get_provider_branches_repository.dart';
import 'package:sun_web_system/features/store_page/data/request/get_provider_branches_request/get_provider_branches_request.dart';
import 'package:sun_web_system/features/store_page/data/datasource/update_branch_datasource/update_branch_repository.dart';
import 'package:sun_web_system/features/store_page/data/model/get_provider_branches_model/provider_branch_model.dart';
import 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit() : super(BranchInitial());

  List<ProviderBranchModel> branches = [];
  final Set<int> _pendingDeletedBranchIds = <int>{};

  int? myUserId;

  Future<void> _initUser() async {
    final user = await AuthLocalStorage.getUser();
    final userId = user?.userid;
    if (userId == null) {
      throw Exception('User not found');
    }

    if (myUserId != null && myUserId != userId) {
      branches = [];
      _pendingDeletedBranchIds.clear();
      selectedBranchId = 0;
    }
    myUserId = userId;
  }

  int selectedBranchId = 0;

  Future<void> getProviderBranches({bool fromSubmit = false}) async {
    try {
      await _initUser();
      emit(BranchLoading());

      final fetchedBranches = await getProviderBranchesFunction(
        getProviderBranchesRequest: GetProviderBranchesRequest(
          providerId: myUserId!,
        ),
      );

      // A read immediately after a successful soft delete can briefly return
      // stale active data. Keep deleted branches hidden until the API confirms
      // that they are no longer active (or no longer returned).
      _pendingDeletedBranchIds.removeWhere(
        (deletedBranchId) => !fetchedBranches.any(
          (branch) =>
              branch.branchId == deletedBranchId && branch.isActive == true,
        ),
      );
      branches = fetchedBranches
          .where(
            (branch) => !_pendingDeletedBranchIds.contains(branch.branchId),
          )
          .toList();

      emit(
        BranchSuccess(
          branches: branches,
          fromSubmit: fromSubmit,
        ),
      );
    } catch (e) {
      final error = e.toString().replaceAll(
            "Exception: ",
            "",
          );

      /// 👇 لو مفيش فروع
      if (error.contains("غير موجود")) {
        emit(
          BranchSuccess(
            branches: [],
          ),
        );

        return;
      }

      emit(
        BranchError(
          error,
        ),
      );
    }
  }

  void changeBranch(int branchId) {
    if (selectedBranchId == branchId) {
      return;
    }

    selectedBranchId = branchId;

    emit(
      BranchSelected(
        branchId: branchId,
      ),
    );
  }

  void goToAdd() {
    final current = state as BranchSuccess;

    emit(
      current.copyWith(
        isAdding: true,
        editingBranchId: null,
        fromSubmit: false,
      ),
    );
  }

  void edit(int branchId) {
    final current = state as BranchSuccess;

    emit(
      current.copyWith(
        isAdding: true,
        editingBranchId: branchId,
        fromSubmit: false,
      ),
    );
  }

  void back() {
    final current = state as BranchSuccess;

    emit(
      current.copyWith(
        isAdding: false,
        editingBranchId: null,
        fromSubmit: false,
      ),
    );
  }

  Future<void> addBranch(
    AddBranchRequest request,
  ) async {
    try {
      await _initUser();

      final body = request.toJson(myUserId!);

      final response = await addBranchFunction(
        body: body,
      );

      final responseData = response.data;

      final bool success = responseData["success"] ?? false;

      if (!success) {
        throw Exception(
          responseData["message"] ?? "Something went wrong",
        );
      }

      await getProviderBranches(fromSubmit: true);
    } catch (e) {
      emit(
        BranchError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateBranch(
    AddBranchRequest request,
  ) async {
    try {
      await _initUser();

      final body = request.toJson(myUserId!);

      final response = await updateBranchFunction(
        body: body,
      );

      final responseData = response.data;

      final bool success = responseData["success"] ?? false;

      if (!success) {
        throw Exception(
          responseData["message"] ?? "Something went wrong",
        );
      }

      await getProviderBranches(fromSubmit: true);
    } catch (e) {
      emit(
        BranchError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deleteBranch(
    int branchId,
  ) async {
    try {
      await _initUser();

      final request = AddBranchRequest(
        branchId: branchId,
        isActive: false,
      );

      final response = await updateBranchFunction(
        body: request.toJson(myUserId!),
      );

      final responseData = response.data;

      final bool success = responseData["success"] ?? false;

      if (!success) {
        throw Exception(
          responseData["message"] ?? "Delete failed",
        );
      }

      _pendingDeletedBranchIds.add(branchId);
      branches = branches
          .where(
            (branch) => branch.branchId != branchId,
          )
          .toList();

      if (selectedBranchId == branchId) {
        selectedBranchId = 0;
      }

      emit(
        BranchSuccess(
          branches: branches,
          fromSubmit: true,
        ),
      );
    } catch (e) {
      emit(
        BranchError(
          e.toString(),
        ),
      );
    }
  }
}
