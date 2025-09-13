import 'dart:async';
import 'package:flutter/foundation.dart';

/// Bridges a Stream to a Listenable for go_router's refreshListenable.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    // Using asBroadcastStream avoids multiple listeners issues upstream
    _sub = stream.asBroadcastStream().listen((_) {
      // Any event should trigger a rebuild of router redirects
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
