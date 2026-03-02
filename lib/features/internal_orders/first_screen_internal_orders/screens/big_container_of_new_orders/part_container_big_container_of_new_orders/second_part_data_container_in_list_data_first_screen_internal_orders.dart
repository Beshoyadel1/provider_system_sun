import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/api/dio_function/apiRoutes.dart';
import '../../../../../../core/api_functions/user/login_model/login_repository.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import '../../../../../../features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../features/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';

class SecondPartDataContainerInListDataFirstScreenInternalOrders
    extends StatefulWidget {
  const SecondPartDataContainerInListDataFirstScreenInternalOrders({
    super.key,
  });

  @override
  State<SecondPartDataContainerInListDataFirstScreenInternalOrders>
  createState() =>
      _SecondPartDataContainerInListDataFirstScreenInternalOrdersState();
}

class _SecondPartDataContainerInListDataFirstScreenInternalOrdersState
    extends State<
        SecondPartDataContainerInListDataFirstScreenInternalOrders> {

  int? providerId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthLocalStorage.getUser();

    if (user != null) {
      providerId = user.userid;
      setState(() {});
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return "${parsed.day}/${parsed.month}/${parsed.year}";
  }

  @override
  Widget build(BuildContext context) {

    if (providerId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create: (_) => GetProviderInternalOrderCubit()
        ..getProviderInternalOrders(
          providerId: providerId!,
          serviceId: MainCategoryConstants.maintenanceAndInternalServicesID,
        ),
      child: BlocBuilder<GetProviderInternalOrderCubit,
          GetProviderInternalOrderState>(
        builder: (context, state) {
          if (state is GetProviderInternalOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetProviderInternalOrderSuccess) {
            final orders = state.orders;

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                final order = orders[index];
                final service = order.services?.isNotEmpty == true
                    ? order.services!.first
                    : null;

                final isEnglish =
                    Localizations.localeOf(context).languageCode == 'en';

                final serviceTitle = isEnglish
                    ? (service?.latinName ?? "")
                    : (service?.name ?? "");

                return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                  imagePathPart1: AppImageKeys.service33,
                  titlePart1: serviceTitle,
                  subTitlePart1: '',
                  imagePathPart2: AppImageKeys.car501,
                  textCarPart2: order.branchName ?? "",
                  titlePart2: order.providerName ?? "",
                  imagePathPart3: AppImageKeys.person22,
                  titlePart3: AppLanguageKeys.name,
                  subTitlePart3: order.username ?? "",
                  status: order.orderStatus,
                  timePart5: _formatDate(order.orderDate),
                  pricePart6: order.totalPrice?.toString() ?? "10",
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
