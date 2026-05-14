import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/accounts_management/presentation/custom_widget/design_container_image_with_two_text_widget.dart';
import 'package:sun_web_system/features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_cubit.dart';
import 'package:sun_web_system/features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_state.dart';
import '../../../../../../core/theming/assets.dart';

class PartOfListContainerInFirstScreenAccountsManagementAdminSun extends StatelessWidget {
  const PartOfListContainerInFirstScreenAccountsManagementAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.accountBalanceKey,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),

        BlocBuilder<ProviderBalanceCubit, ProviderBalanceState>(
          builder: (context, state) {

            if (state is ProviderBalanceLoading) {
              return const CupertinoActivityIndicator();
            }

            if (state is ProviderBalanceError) {
              return const SizedBox();
            }

            if (state is ProviderBalanceSuccess) {
              final model = state.model;

              return _buildRow(
                model.totalBalance.toString(),
                model.electronicBalance.toString(),
                model.cashBalance.toString(),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildRow(String total, String electronic, String cash) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: [
        CustomContainer(
          isSelected: false,
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          typeWidget: DesignContainerImageWithTwoTextWidget(
            imagePath: AppImageKeys.account_sun2,
            title: AppLanguageKeys.allPayments,
            subTitle: total,
          ),
        ),
        CustomContainer(
          isSelected: false,
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          typeWidget: DesignContainerImageWithTwoTextWidget(
            imagePath: AppImageKeys.account_sun2,
            title: AppLanguageKeys.cardPayments,
            subTitle: electronic,
          ),
        ),
        CustomContainer(
          isSelected: false,
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          typeWidget: DesignContainerImageWithTwoTextWidget(
            imagePath: AppImageKeys.account_sun2,
            title: AppLanguageKeys.cashOnDeliveryPayments,
            subTitle: cash,
          ),
        ),
      ],
    );
  }
}