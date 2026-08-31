import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/store_page/data/model/facility_model/facility_model.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/car_model_widget/widgets/tabs_widget.dart';
import 'package:sun_web_system/features/store_page/presentation/pages/store_widgets/facility_account/tabs/facility_data_content.dart';
import '../../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import '../../../../../../../features/store_page/presentation/bloc/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../core/language/language_constant.dart';

class FacilityAccountCheck extends StatefulWidget {
  const FacilityAccountCheck({
    super.key,
  });

  @override
  State<FacilityAccountCheck> createState() => _FacilityAccountCheckState();
}

class _FacilityAccountCheckState extends State<FacilityAccountCheck> {
  final GlobalKey<FacilityDataContentState> facilityDataKey =
      GlobalKey<FacilityDataContentState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: BlocProvider(
        create: (_) => FacilityTabCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthIncompleteProfile) {
              AppSnackBar.showError(
                state.missing.first,
              );
            }

            if (state is AuthUpdateError) {
              AppSnackBar.showError(
                state.error,
              );
            }

            if (state is AuthAuthenticated) {
              print(
                "✅ FACILITY IS VALID",
              );
            }
          },
          builder: (context, authState) {
            return BlocBuilder<FacilityTabCubit, FacilityTabState>(
              buildWhen: (previous, current) => current is ChangeIndexState,
              builder: (context, state) {
                final facilityCubit = context.read<FacilityTabCubit>();

                final index = facilityCubit.selectedIndex;

                return Padding(
                  padding: const EdgeInsets.all(16),
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
                              const TextInAppWidget(
                                text: AppLanguageKeys.continueFacilityDataKey,
                                textSize: 22,
                                fontWeightIndex:
                                    FontSelectionData.mediumFontFamily,
                              ),

                              const TabsWidget(),

                              // =================================================
                              // FACILITY DATA
                              // =================================================

                              index == 0
                                  ? FacilityDataContent(
                                      key: facilityDataKey,
                                    )
                                  : facilityTabs[index].content,

                              // =================================================
                              // BUTTONS
                              // =================================================

                              Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Flexible(
                                    child: CustomContainer(
                                      containerWidth: 500,
                                      isSelected: false,
                                      onTap: authState is AuthLoading
                                          ? null
                                          : () async {
                                              print(
                                                "🔘 CHECK BUTTON CLICKED",
                                              );

                                              // ======================================
                                              // 1. GET CURRENT SCREEN DATA
                                              // ======================================

                                              if (index == 0) {
                                                final dataState =
                                                    facilityDataKey
                                                        .currentState;

                                                if (dataState == null) {
                                                  AppSnackBar.showError(
                                                    'Facility data is not ready',
                                                  );

                                                  return;
                                                }

                                                await dataState
                                                    .prepareDataForCheck();
                                              }

                                              // ======================================
                                              // 2. CHECK
                                              // ======================================

                                              await context
                                                  .read<AuthCubit>()
                                                  .reCheckFacility();
                                            },
                                      containerColor: AppColors.orangeColor,
                                      containerHeight: 45,
                                      typeWidget: Center(
                                        child: authState is AuthLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const TextInAppWidget(
                                                text:
                                                    AppLanguageKeys.enterSystem,
                                                textSize: 16,
                                                textColor: Colors.white,
                                              ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                    child: CustomContainer(
                                      containerWidth: 500,
                                      isSelected: false,
                                      onTap: () {
                                        context
                                            .read<AuthCubit>()
                                            .clearCheckUser();

                                        context.read<AuthCubit>().logout(
                                              context,
                                            );
                                      },
                                      containerColor: AppColors.redColor,
                                      containerHeight: 45,
                                      typeWidget: const Center(
                                        child: TextInAppWidget(
                                          text: AppLanguageKeys.logout,
                                          textSize: 16,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
