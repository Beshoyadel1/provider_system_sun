import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/store_page/data/model/facility_model/facility_model.dart';
import '../../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import '../../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';

class TabsWidgetEmp extends StatelessWidget {
  final List<FacilityModel> tabs;

  const TabsWidgetEmp({
    super.key,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FacilityTabCubit, FacilityTabState>(
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            tabs.length,
                (index) {
              final isSelected =
                  context.read<FacilityTabCubit>().selectedIndex == index;

              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 150,
                ),
                child: CustomContainer(
                  isSelected: isSelected,
                  onTap: () => context
                      .read<FacilityTabCubit>()
                      .selectTab(index),
                  text: tabs[index].title,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  containerColor: isSelected
                      ? AppColors.orangeColor
                      : AppColors.greyColor,
                  border: const Border(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}