import '../../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../main.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/features/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:sun_web_system/features/order_status_design/presentation/pages/order_details/order_details.dart';
import 'package:sun_web_system/features/technical_support/data/model/provider_chat_model.dart';
import 'package:sun_web_system/features/technical_support/presentation/bloc/provider_chat_cubit/provider_chat_cubit.dart';
import 'package:sun_web_system/features/technical_support/presentation/pages/provider_chat_page.dart';
import 'package:sun_web_system/features/technical_support/presentation/pages/mobile_chat_page.dart';
import '../../../data/model/notification_payload.dart';
import '../../../data/notification_updates.dart';
import '../../pages/notifications_page/notifications_page.dart';
import 'package:sun_web_system/features/service_requests/presentation/pages/service_requests_page.dart';


class NotificationNavigationService {
  const NotificationNavigationService();

  void openPayload(NotificationPayload payload) {
    final context = navigatorKey.currentContext;
    final navigator = navigatorKey.currentState;
    if (context == null || navigator == null) return;
    if (payload.isOrder && (payload.orderId ?? 0) > 0) {
      final patch = NotificationUpdates.instance.orders[payload.orderId] ?? payload.orderPatch;
      // Full details are fetched once by the details screen, only when opened.
      navigator.push(MaterialPageRoute(builder: (_) =>
          OrderDetails(order: OrderModel().applyPatch(patch))));
    } else if (payload.kind == NotificationKind.chat || payload.kind == NotificationKind.chatStatus) {
      final id = payload.integer('fromuser');
      final type = payload.integer('fromusertype');
      if (id == null || type == null) return;
      final cubit = getIt<ProviderChatCubit>();
      final chat = cubit.state.allMessages.where((c) => c.touser == id && c.tousertype == type);
      cubit.selectChat(chat.isNotEmpty ? chat.first : GetAllMessagesModel(
        touser: id, tousertype: type, userName: payload.get('fromusername')?.toString() ?? payload.title,
      ));
      navigator.push(MaterialPageRoute(builder: (_) =>
          MediaQuery.sizeOf(context).width < 600 ? const MobileChatPage() : const ProviderChatPage()));
    } else if (payload.kind == NotificationKind.serviceRequest && payload.integer('requestId') != null) {
      navigator.push(MaterialPageRoute(builder: (_) => Scaffold(
        appBar: AppBar(title: Text(Localizations.localeOf(context).languageCode == 'ar' ? 'طلب الخدمة' : 'Service request')),
        body: ServiceRequestsPage(initialRequestId: payload.integer('requestId')),
      )));
    } else {
      navigator.push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
    }
  }

  void openDashboardOrders() {
    final context = navigatorKey.currentContext;

    if (context == null) return;

    AppCubit.get(context).navigateToPage(
      PagesOfAllApp.dashboardPageNumber,
    );
  }
  void openChat() {
    final context = navigatorKey.currentContext;

    if (context == null) return;

    AppCubit.get(context).navigateToPage(
      PagesOfAllApp.technicalSupportPageNumber,
    );
  }
}
