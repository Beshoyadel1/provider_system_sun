import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/branch/add_branch_model/add_branch_request.dart';
import 'package:sun_web_system/features/store_page/logic/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/logic/branch_cubit/branch_state.dart';
import '../../../../../features/store_page/model/location_cubit/location_cubit.dart';
import '../../../../../features/store_page/model/location_cubit/location_state.dart';
import '../../../../../features/store_page/model/branch_model/branch_model_dashboard.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../../../features/store_page/model/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../core/language/language_constant.dart';
import 'square_map_widget.dart';

class AddBranchUI extends StatelessWidget {
  AddBranchUI({super.key});

  final nameController = TextEditingController();
  final latinController = TextEditingController();
  final addressTextController = TextEditingController();
  final addressLatinController = TextEditingController();
  final addressController  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BranchCubit>();
    final state = cubit.state as BranchSuccess;

    if (state.editingIndex != null) {
      final branch = state.branches[state.editingIndex!];

      nameController.text = branch.branchName ?? '';
      latinController.text = branch.branchLatinName ?? '';
      addressTextController.text = branch.addressText ?? '';
      addressLatinController.text = branch.addressLatinText ?? '';
      addressController.text = branch.address ?? '';
    }

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: state.editingIndex != null
              ? AppLanguageKeys.editKey
              : AppLanguageKeys.addMainBranchKey,
          textSize: 20,
        ),

        TextFormFieldWidget(
          textFormController: nameController,
          text: AppLanguageKeys.branchName,
          hintText: AppLanguageKeys.branchName,
          textSize: 16,
          isColumn: true,
          textColor: AppColors.darkColor,
          borderColor: AppColors.darkGreyColor,
          //borderRadius: 20,
          fillColor: AppColors.whiteColor,
          textFormHeight: 35,
        ),

        TextFormFieldWidget(
          textFormController: latinController,
          text: AppLanguageKeys.branchLatinName,
          hintText: AppLanguageKeys.branchLatinName,
          textSize: 16,
          isColumn: true,
          textColor: AppColors.darkColor,
          borderColor: AppColors.darkGreyColor,
          //borderRadius: 20,
          fillColor: AppColors.whiteColor,
          textFormHeight: 35,
        ),

        TextFormFieldWidget(
          textFormController: addressTextController,
          text: AppLanguageKeys.addressText,
          hintText: AppLanguageKeys.addressText,
          textSize: 16,
          isColumn: true,
          textColor: AppColors.darkColor,
          borderColor: AppColors.darkGreyColor,
          //borderRadius: 20,
          fillColor: AppColors.whiteColor,
          textFormHeight: 35,
        ),

        TextFormFieldWidget(
          textFormController: addressLatinController,
          text: AppLanguageKeys.addressLatinText,
          hintText: AppLanguageKeys.addressLatinText,
          textSize: 16,
          isColumn: true,
          textColor: AppColors.darkColor,
          borderColor: AppColors.darkGreyColor,
          //borderRadius: 20,
          fillColor: AppColors.whiteColor,
          textFormHeight: 35,
        ),

        TextFormFieldWidget(
          textFormController: addressController,
          text: AppLanguageKeys.branchAddressKey,
          isColumn: true,
          textColor: AppColors.darkGreyColor,
          fillColor: AppColors.whiteColor,
          textSize: 16,
          hintText: AppLanguageKeys.addressDetailsKey,
          textFormHeight: 35,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          borderColor: AppColors.lightGreyColor,
          //borderRadius: 20,
          onChanged: (value) {
            if (value.trim().isNotEmpty) {
              context.read<LocationCubit>().searchLocation(value.trim());
            }
          },
        ),

        const TextInAppWidget(
          text: AppLanguageKeys.confirmBranchLocationKey,
          textSize: 18,
        ),

        SizedBox(
          height: 370,
          width: 408,
          child: SquareMapWidget(),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            CustomContainer(
              isSelected: false,
              onTap: () {
                final locationState = context.read<LocationCubit>().state;

                if (locationState is LocationLoaded) {
                  final cubit = context.read<BranchCubit>();

                  if (state.editingIndex != null) {
                    final branch = state.branches[state.editingIndex!];

                    final request = AddBranchRequest(
                      branchId: branch.branchId,
                      branchName: nameController.text,
                      branchLatinName: latinController.text,
                      address:
                      "${locationState.latLng.latitude},${locationState.latLng.longitude}",
                      addressText: addressTextController.text,
                      addressLatinText: addressLatinController.text,
                      isActive: branch.isActive ?? false,
                    );

                    cubit.updateBranch(state.editingIndex!, request);
                  }

                  // ✅ حالة CREATE
                  else {
                    final request = AddBranchRequest(
                      branchName: nameController.text,
                      branchLatinName: latinController.text,
                      address:
                      "${locationState.latLng.latitude},${locationState.latLng.longitude}",
                      addressText: addressTextController.text,
                      addressLatinText: addressLatinController.text,
                      isActive: false, // أو true حسب business
                    );

                    cubit.addBranch(request);
                  }
                }
              },
              text: state.editingIndex != null
                  ? AppLanguageKeys.editKey
                  : AppLanguageKeys.saveKey,
              containerColor: AppColors.orangeColor,
            ),
            CustomContainer(
              isSelected: false,
              onTap: () {
                context.read<BranchCubit>().back();
              },
              text: AppLanguageKeys.cancel,
              containerColor: AppColors.blackColor,
            ),
          ],
        )

      ],
    );
  }
}
