import 'package:flutter/material.dart';
import 'package:sun_web_system/features/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/features/technical_support/presentation/bloc/provider_chat_cubit/provider_chat_cubit.dart';
import 'package:sun_web_system/features/technical_support/presentation/pages/mobile_chat_page.dart';
import 'package:sun_web_system/features/technical_support/presentation/pages/provider_chat_page.dart';
import '../../../custom_widget/container_contact_with_customer_order_details_widget.dart';

class ContainerContactWithCustomerOrderDetails extends StatefulWidget {
  const ContainerContactWithCustomerOrderDetails(
      {super.key, required this.orderDetailsModel});
  final OrderDetailsModel orderDetailsModel;
  @override
  State<ContainerContactWithCustomerOrderDetails> createState() =>
      _ContactState();
}

class _ContactState extends State<ContainerContactWithCustomerOrderDetails> {
  bool _opening = false;

  Future<void> _openChat() async {
    if (_opening) return;
    setState(() => _opening = true);
    final details = widget.orderDetailsModel;
    try {
      final opened = await getIt<ProviderChatCubit>().openContactChat(
          userId: details.user?.userid ?? details.userid ?? 0,
          userType: details.user?.usertype ?? details.usertype ?? 0,
          name: details.user?.username,
          image: details.user?.image);
      if (!mounted) return;
      if (!opened) throw StateError('Customer conversation unavailable');
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MediaQuery.sizeOf(context).width < 600
              ? const MobileChatPage()
              : const ProviderChatPage(isStandalone: true)));
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Localizations.localeOf(context).languageCode == 'ar'
                ? 'تعذر فتح المحادثة. حاول مرة أخرى'
                : 'Could not open conversation. Try again')));
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.orderDetailsModel;
    final id = details.user?.userid ?? details.userid ?? 0;
    final type = details.user?.usertype ?? details.usertype ?? 0;
    return ContainerContactWithCustomerOrderDetailsWidget(
        imageUser: details.user?.image,
        nameCustomer: details.user?.username,
        phone: details.user?.phone,
        onMessage: !_opening && id > 0 && type > 0 ? _openChat : null);
  }
}
