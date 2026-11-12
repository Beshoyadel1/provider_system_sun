import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';

class SignalRConnection {
  SignalRConnection._();

  static final SignalRConnection instance = SignalRConnection._();

  final ValueNotifier<HubConnectionState> connectionState =
  ValueNotifier(HubConnectionState.disconnected);

  HubConnection? _hubConnection;

  String? _hubUrl;
  VoidCallback? _onReconnect;
  Future<void> Function(dynamic error)? _onClose;

  // Track whether the user manually called disconnect()
  bool _isExplicitDisconnect = false;

  HubConnection? get hub => _hubConnection;

  bool get isConnected =>
      _hubConnection?.state == HubConnectionState.connected;

  bool get isConnecting =>
      _hubConnection?.state == HubConnectionState.connecting;

  Future<void> connect({
    required String hubUrl,
    required VoidCallback onReconnect,
    required Future<void> Function(dynamic error) onClose,
  }) async {
    _hubUrl = hubUrl;
    _onReconnect = onReconnect;
    _onClose = onClose;
    _isExplicitDisconnect = false; // Reset flag on a new manual connection attempt

    if (isConnected || isConnecting) return;

    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withAutomaticReconnect([
        10000,
        15000,
        20000,
        30000,
        60000,
        180000,
      ])
          .withUrl(
        hubUrl,
        HttpConnectionOptions(
          transport: HttpTransportType.longPolling,
        ),
      )
          .build();

      _hubConnection!.serverTimeoutInMilliseconds = 60000;
      _hubConnection!.keepAliveIntervalInMilliseconds = 15000;

      _hubConnection!.onreconnecting((_) {
        connectionState.value = HubConnectionState.reconnecting;
      });

      _hubConnection!.onreconnected((_) {
        connectionState.value = HubConnectionState.connected;
        _onReconnect?.call();
      });

      _hubConnection!.onclose((error) async {
        connectionState.value = HubConnectionState.disconnected;

        await _onClose?.call(error);

        // Only trigger manual reconnect if this wasn't an intentional stop() call
        if (!_isExplicitDisconnect) {
          reconnect();
        }
      });
    }

    connectionState.value = HubConnectionState.connecting;

    try {
      if (_hubConnection!.state == HubConnectionState.disconnected) {
        await _hubConnection!.start();

        connectionState.value = HubConnectionState.connected;
        _onReconnect?.call();
      }
    } catch (_) {
      connectionState.value = HubConnectionState.disconnected;

      try {
        await _hubConnection?.stop();
      } catch (_) {}

      _hubConnection = null;
      rethrow;
    }
  }

  /// Attempts to re-establish the connection.
  /// If variables are missing, it falls back to a default hub URL.
  Future<void> reconnect() async {
    final targetUrl = _hubUrl ?? ApiLink.notificationHub;
    final targetOnReconnect = _onReconnect ?? () {};
    final targetOnClose = _onClose ?? (_) async {};

    // Clean up the previous connection safely, but make sure it doesn't wipe our callbacks
    // before we pass them to the new connect() call.
    await _softDisconnect();

    try {
      await connect(
        hubUrl: targetUrl,
        onReconnect: targetOnReconnect,
        onClose: targetOnClose,
      );
    } catch (_) {
      // Wait before trying again to prevent CPU spiking in case the server is completely down
      await Future.delayed(const Duration(seconds: 10));
      if (!_isExplicitDisconnect) {
        reconnect();
      }
    }
  }

  /// Internal helper to tear down the connection state without clearing
  /// critical reconnection variables like [_hubUrl], [_onReconnect], and [_onClose].
  Future<void> _softDisconnect() async {
    if (_hubConnection == null) return;

    try {
      await _hubConnection!
          .stop()
          .timeout(const Duration(seconds: 3));
    } catch (_) {} finally {
      connectionState.value = HubConnectionState.disconnected;
      _hubConnection = null;
    }
  }

  /// Explicitly stop and teardown the signalR connection.
  /// Will NOT trigger automatic reconnection loops.
  Future<void> disconnect() async {
    _isExplicitDisconnect = true;
    if (_hubConnection == null) {
      return;
    }

    try {
      await _hubConnection!
          .stop()
          .timeout(const Duration(seconds: 3));
    } catch (_) {} finally {
      connectionState.value = HubConnectionState.disconnected;
      _hubConnection = null;
      _hubUrl = null;
      _onReconnect = null;
      _onClose = null;
    }
  }
}