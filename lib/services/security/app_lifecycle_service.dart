import 'package:flutter/widgets.dart';

class AppLifecycleService
    with WidgetsBindingObserver {
  AppLifecycleService._();

  static final AppLifecycleService instance =
      AppLifecycleService._();

  Future<void> Function()? _onBackground;
  Future<void> Function()? _onForeground;

  void initialize({
    Future<void> Function()? onBackground,
    Future<void> Function()? onForeground,
  }) {
    _onBackground = onBackground;
    _onForeground = onForeground;

    WidgetsBinding.instance
        .addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _onBackground?.call();
    }

    if (state == AppLifecycleState.resumed) {
      _onForeground?.call();
    }
  }

  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this);

    _onBackground = null;
    _onForeground = null;
  }
}
