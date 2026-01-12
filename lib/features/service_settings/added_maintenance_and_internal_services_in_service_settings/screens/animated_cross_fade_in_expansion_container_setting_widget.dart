import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/row_radio_list_tile_setting.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/data_view_of_price_per_category.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/data_view_of_unified_price_for_all.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';

class AnimatedCrossFadeInExpansionContainerSettingWidget
    extends StatelessWidget {
  const AnimatedCrossFadeInExpansionContainerSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsContainerSettingCubit,
        DetailsContainerSettingState>(
      buildWhen: (previous, current) {
        return previous.isExpanded != current.isExpanded ||
            previous.selectedOption != current.selectedOption;
      },
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: state.isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowRadioListTileSetting(),
                    if (state.selectedOption == 0)
                      const DataViewOfUnifiedPriceForAll()
                    else if (state.selectedOption == 1)
                      const DataViewOfPricePerCategory(),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
