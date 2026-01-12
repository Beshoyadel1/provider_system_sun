import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/service_settings/custom_widget/custom_widget_radio_list_tile.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';

class RowRadioListTileSetting extends StatelessWidget {
  const RowRadioListTileSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        DetailsContainerSettingCubit,
        DetailsContainerSettingState>(
        buildWhen: (previous, current) =>
        previous.selectedOption != current.selectedOption,
        builder: (context, state) {
          return const Row(
            children: [
              CustomWidgetRadioListTile(
                  text: AppLanguageKeys.unifiedPriceForAll,
                  value: 0
              ),
              CustomWidgetRadioListTile(
                  text: AppLanguageKeys.pricePerCategory,
                  value: 1
              ),
            ],
          );
        }
    );
  }
}
