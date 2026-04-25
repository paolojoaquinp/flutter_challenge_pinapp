import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a stream of boolean representing internet connection status.
/// Emits `true` if connected to any network interface, `false` if `ConnectivityResult.none`.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  bool isConnected(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    // According to connectivity_plus v6+, single item with ConnectivityResult.none means offline
    if (results.length == 1 && results.first == ConnectivityResult.none) {
      return false;
    }
    // Alternatively, if it contains none along with others (unlikely, but just in case)
    return !results.contains(ConnectivityResult.none);
  }

  // Yield initial connectivity state
  yield isConnected(await connectivity.checkConnectivity());

  // Listen and yield connectivity changes
  await for (final results in connectivity.onConnectivityChanged) {
    yield isConnected(results);
  }
});
