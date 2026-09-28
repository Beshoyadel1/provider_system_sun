import 'package:flutter/cupertino.dart';
import 'package:signalr_core/signalr_core.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';

class SignalREventRegister {
  final void Function(List<Object?>?) onReceiveNotification;
  final void Function(List<Object?>?) onReceiveMessage;
  final void Function(List<Object?>?) onNewOrder;
  final void Function(List<Object?>?) onUpdateOrderStatus;
  final void Function(List<Object?>?) onNewServiceRequest;
  final void Function(List<Object?>?) onNewServiceOffer;
  final void Function(List<Object?>?) onTransferCarOwnership;
  final void Function(List<Object?>?) onOpenCloseChat;

  SignalREventRegister({
    required this.onReceiveNotification,
    required this.onReceiveMessage,
    required this.onNewOrder,
    required this.onUpdateOrderStatus,
    required this.onNewServiceRequest,
    required this.onNewServiceOffer,
    required this.onTransferCarOwnership,
    required this.onOpenCloseChat,
  });
  void unregister(HubConnection connection) {
    connection.off(SignalRTypes.receiveNotification);
    connection.off(SignalRTypes.receiveMessage);
    connection.off(SignalRTypes.newOrder);
    connection.off(SignalRTypes.updateOrderStatus);
    connection.off(SignalRTypes.newServiceRequest);
    connection.off(SignalRTypes.newServiceOffer);
    connection.off(SignalRTypes.transferCarOwnership);
    connection.off(SignalRTypes.openCloseChat);
  }
  void register(HubConnection connection) {
    unregister(connection);
    debugPrint("✅ Registering SignalR Events");

    connection.on(
      SignalRTypes.receiveNotification,
          (args) {
        debugPrint("🔥 ReceiveNotification Event Fired");
        onReceiveNotification(args);
      },
    );
    // connection.on(
    //   SignalRTypes.receiveMessage,
    //       (args) {
    //     _logEvent(SignalRTypes.receiveMessage, args);
    //     onReceiveMessage(args);
    //   },
    // );

    connection.on(
      SignalRTypes.receiveMessage,
      onReceiveMessage
    );

    connection.on(
      SignalRTypes.newOrder,
      onNewOrder
    );

    connection.on(
      SignalRTypes.updateOrderStatus,
      onUpdateOrderStatus,
    );

    connection.on(
      SignalRTypes.newServiceRequest,
      onNewServiceRequest,
    );

    connection.on(
      SignalRTypes.newServiceOffer,
      onNewServiceOffer,
    );

    connection.on(
      SignalRTypes.transferCarOwnership,
      onTransferCarOwnership,
    );

    connection.on(
      SignalRTypes.openCloseChat,
      onOpenCloseChat,
    );
  }
}