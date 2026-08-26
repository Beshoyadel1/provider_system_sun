import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/cubit/app_cubit/app_cubit.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'package:sun_web_system/features/order_status_design/presentation/custom_widget/show_order_status_confirmation_dialog.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import '../../../../../../../../features/warranty/presentation/bloc/warranty_cubit.dart';
import '../../../../../../../../features/warranty/presentation/bloc/warranty_state.dart';
import '../../../../../../../../features/warranty/presentation/custom_widget/widget_design_list_warranty.dart';
import '../../../../../../../../features/warranty/presentation/pages/page_details_warranty/page_details_warranty.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import '../../../../../../../../features/warranty/presentation/bloc/warranty_cubit.dart';
import '../../../../../../../../features/warranty/presentation/bloc/warranty_state.dart';
import '../../../../../../../../features/warranty/presentation/custom_widget/widget_design_list_warranty.dart';

class ListViewAllWarranty extends StatelessWidget {
  const ListViewAllWarranty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<WarrantyCubit, WarrantyState>(
      listener: (context, state) async {
        // =========================================================
        // APPROVE SUCCESS
        // =========================================================

        if (state is WarrantyApproveProviderSuccess) {
           await AuthLocalStorage.updateUserFields(
            isApproved: true,
          );
           final refreshed = await AuthLocalStorage.refreshAndSaveUser();

           if (!refreshed) {
             // handle error
             return;
           }
          AppSnackBar.showSuccess(
            AppLanguageKeys.subscriptionSuccess,
          );

          AppCubit.get(context).navigateToPage(
            PagesOfAllApp.permissionsGroupPageNumber,
          );
        }

        // =========================================================
        // APPROVE ERROR
        // =========================================================

        if (state is WarrantyApproveProviderError) {
          AppSnackBar.showError(state.message);
        }
      },
      child: BlocBuilder<WarrantyCubit, WarrantyState>(
        builder: (context, state) {
          // =======================================================
          // LOADING GET ALL
          // =======================================================

          if (state is WarrantyLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =======================================================
          // ERROR GET ALL
          // =======================================================

          if (state is WarrantyError) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          }

          // =======================================================
          // SUCCESS GET ALL
          // =======================================================

          if (state is WarrantySuccess) {
            if (state.warranties.isEmpty) {
              return const Center(
                child: TextEmptyViewData(),
              );
            }

            return CustomContainer(
              isSelected: false,
              onTap: () {},
              typeWidget: ListView.separated(
                itemCount: state.warranties.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemBuilder: (context, index) {
                  final warranty = state.warranties[index];

                  final id = warranty.id;

                  return WidgetDesignListWarranty(
                    warrantyId: warranty.id,
                    price: warranty.price,
                    durationTypeId: warranty.durationtype,
                    durationValue: warranty.durationvalue,

                    onTapSubscription: () async {
                      if (id == null || id <= 0) {
                        return;
                      }

                      final bool? confirmed =
                      await showOrderStatusConfirmationDialog(
                        context,
                        actionText: AppLanguageKeys.subscription,
                        actionColor: AppColors.orangeColor,
                      );

                      if (confirmed != true) {
                        return;
                      }

                      if (!context.mounted) {
                        return;
                      }

                      context.read<WarrantyCubit>().approveProvider(
                        approvalId: id,
                      );
                    },
                  );
                },
              ),
            );
          }

          // =======================================================
          // APPROVE STATES
          // =======================================================

          if (state is WarrantyApproveProviderLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}