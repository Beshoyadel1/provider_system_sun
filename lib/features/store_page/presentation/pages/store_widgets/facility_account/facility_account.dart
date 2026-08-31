import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/car_model_widget/widgets/tabs_widget.dart';
import '../../../../../../../features/store_page/data/model/facility_model/facility_model.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';

class FacilityAccount extends StatelessWidget {
  const FacilityAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FacilityTabCubit(),
      child: BlocBuilder<FacilityTabCubit, FacilityTabState>(
        buildWhen: (previous, current) => current is ChangeIndexState,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomContainer(
                    containerWidth: double.infinity,
                    isSelected: false,
                    typeWidget: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TabsWidget(),
                        facilityTabs[
                        context.read<FacilityTabCubit>().selectedIndex]
                            .content,
                        // const SizedBox(height: 100),
                        // const FacilityDataContent()
                      ],
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
