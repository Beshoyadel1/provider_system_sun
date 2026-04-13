import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/accounts_management/first_screen_accounts_management_admin_sun/screens/account_balance.dart';
import 'package:sun_web_system/features/accounts_management/first_screen_accounts_management_admin_sun/screens/all_profits_from_packages_list/all_profits_from_packages_list.dart';
import 'package:sun_web_system/features/accounts_management/first_screen_accounts_management_admin_sun/screens/number_of_transaction_list/number_of_transaction_list.dart';
import 'package:sun_web_system/features/accounts_management/first_screen_accounts_management_admin_sun/screens/part_of_list_container_all_profit_from_package_list.dart';
import 'package:sun_web_system/features/accounts_management/logic/provider_balances_cubit/provider_balances_cubit.dart';

class ListDataFirstScreenAccountsManagementAdminSun extends StatelessWidget {
  const ListDataFirstScreenAccountsManagementAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderBalanceCubit()..getBalanceDetails(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 30,
        children: [
          AccountBalance(),
           PartOfListContainerInFirstScreenAccountsManagementAdminSun(),
          AllProfitsFromPackagesList(),
           NumberOfTransactionList()
          // PartOfListContainerInNumberOfTransactionList(),
          // PartOfListContainerAllProfitFromPackageList()
        ],
      ),
    );
  }
}