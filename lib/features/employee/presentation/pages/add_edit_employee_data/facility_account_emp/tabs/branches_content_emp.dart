import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/add_branch_ui.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/branches_added_ui.dart';


class BranchesContentEmp extends StatelessWidget {
  final EmployeeModel employee;

  const BranchesContentEmp({
    super.key,
    required this.employee,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationCubit(),
      child: BlocBuilder<BranchCubit, BranchState>(
        builder: (context, state) {
          if (state is BranchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BranchError) {
            return Center(child: Text(state.message));
          }

          if (state is BranchSuccess) {
            return state.isAdding
                ? const AddBranchUI()
                : BranchesAddedUi(state:state);
          }

          return const SizedBox();
        },
      ),
    );
  }
}