import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';


class ContainerOpenCloseTabSetting extends StatelessWidget {
  final bool? isDoneTask;

  const ContainerOpenCloseTabSetting({
    super.key,
    this.isDoneTask = false
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        DetailsContainerSettingCubit,
        DetailsContainerSettingState>(
        buildWhen: (previous, current) =>
        previous.isExpanded != current.isExpanded,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: isDoneTask! ? AppColors.orangeColor : AppColors.greyColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () =>
                  context.read<DetailsContainerSettingCubit>().toggle(),
              icon: Icon(
                state.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.whiteColor,
              ),
            ),
          );
        }
    );
  }
}
