import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/cubit/location_cubit/location_cubit.dart';
import '../../../../../../../core/cubit/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import '../../../../../../../core/cubit/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import '../../add_branch_ui.dart';
import '../../branches_added_ui.dart';


class BranchesContent extends StatelessWidget {
  const BranchesContent({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FacilityTabCubit, FacilityTabState>(
      builder: (context, state) {
        final cubit = context.read<FacilityTabCubit>();

        return BlocProvider(
          create: (_) => LocationCubit(),
          child: cubit.isAddingBranch
              ? AddBranchUI()
              : BranchesAddedUi(state: state),
        );
      },
    );
  }
}

