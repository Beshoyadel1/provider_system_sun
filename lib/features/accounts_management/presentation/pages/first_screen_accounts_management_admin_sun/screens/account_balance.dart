import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../features/accounts_management/presentation/bloc/wallet_balance_cubit/wallet_balance_cubit.dart';
import '../../../../../../features/accounts_management/presentation/bloc/wallet_balance_cubit/wallet_balance_state.dart';

import '../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/row_text_icon_orange.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.netBalance,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),

        BlocProvider(
          create: (_) => WalletBalanceCubit()..getWalletBalance(),
          child: BlocBuilder<WalletBalanceCubit, WalletBalanceState>(
            builder: (context, state) {
              if (state is WalletBalanceLoading) {
                return const CupertinoActivityIndicator();
              }

              if (state is WalletBalanceError) {
                return const SizedBox();
              }

              if (state is WalletBalanceSuccess) {

                return RowTextIconOrange(
                  text: state.balance.toString(),
                  imagePath: AppImageKeys.coin,
                  textSize: 20,
                  textColor: AppColors.orangeColor,
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}