import 'package:flutter/material.dart';
import '../../features/technical_support/presentation/bloc/provider_chat_cubit/provider_chat_cubit.dart';

final chatRouteObserver = RouteObserver<PageRoute<dynamic>>();

/// A selected thread under another route is not a conversation the user can read.
class ChatRouteVisibility extends StatefulWidget {
  const ChatRouteVisibility(
      {super.key,
      required this.cubit,
      required this.child,
      this.visible = true});
  final ProviderChatCubit cubit;
  final Widget child;
  final bool visible;
  @override
  State<ChatRouteVisibility> createState() => _ChatRouteVisibilityState();
}

class _ChatRouteVisibilityState extends State<ChatRouteVisibility>
    with RouteAware, WidgetsBindingObserver {
  PageRoute<dynamic>? _route;
  bool _appVisible = true;

  // On the web, inactive means a visible window without keyboard focus.
  // Only hidden/paused/detached means the selected thread cannot be read.
  bool _isAppVisible(AppLifecycleState? state) =>
      state == null ||
      state == AppLifecycleState.resumed ||
      state == AppLifecycleState.inactive;

  @override
  void initState() {
    super.initState();
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _appVisible = _isAppVisible(lifecycle);
    WidgetsBinding.instance.addObserver(this);
  }

  void _update() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.cubit.setChatVisibility(
              widget.visible && _appVisible && (_route?.isCurrent ?? true),
              owner: this);
        }
      });
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute && route != _route) {
      chatRouteObserver.unsubscribe(this);
      _route = route;
      chatRouteObserver.subscribe(this, route);
    }
    _update();
  }

  @override
  void didUpdateWidget(covariant ChatRouteVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) _update();
  }

  @override
  void didPush() => _update();
  @override
  void didPopNext() => _update();
  @override
  void didPushNext() => widget.cubit.setChatVisibility(false, owner: this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appVisible = _isAppVisible(state);
    if (_appVisible) {
      _update();
    } else {
      widget.cubit.setChatVisibility(false, owner: this);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    chatRouteObserver.unsubscribe(this);
    widget.cubit.clearSelectedChat(owner: this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
