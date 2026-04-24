// SRP: This service is solely responsible for fetching and exposing
// Firebase Remote Config values. No business logic lives here.
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

// TODO: review if already implemented feature flags in main
/// Typed wrapper around [FirebaseRemoteConfig].
/// Fetches and activates remote configuration on demand.
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  /// Factory constructor using the default Firebase Remote Config instance.
  factory RemoteConfigService.defaultInstance() {
    return RemoteConfigService(FirebaseRemoteConfig.instance);
  }

  /// Fetches the latest config from Firebase and activates it.
  /// Called by [SplashNotifier] during app initialisation (HU-01).
  Future<void> fetchAndActivate() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        // In debug mode prefer shorter cache so developers see changes quickly.
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(hours: 1),
      ));
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      // Remote config failures must never crash the app.
      // The app will continue with the bundled default values.
      debugPrint('[RemoteConfigService] fetchAndActivate failed: $e');
    }
  }

  // ── Typed feature-flag accessors ──────────────────────────────────────────

  /// Whether the Search tab is visible in HomeScreen.
  bool get isSearchEnabled => _remoteConfig.getBool('is_search_enabled');

  /// Welcome banner text shown on the HomeScreen app bar.
  String get welcomeBannerText =>
      _remoteConfig.getString('welcome_banner_text');
}
