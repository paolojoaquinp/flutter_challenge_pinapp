// SRP: This service is solely responsible for fetching and exposing
// Firebase Remote Config values. No business logic lives here.
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Bundled default values ────────────────────────────────────────────────
// These are used when the device has never successfully fetched config
// (first launch / no network). Always define defaults for every key you use.
const _kRemoteConfigDefaults = <String, dynamic>{
  'is_search_enabled': true,
  'welcome_banner_text': 'Discover your next favourite',
  'min_app_version': '1.0.0',
};

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
      // 1. Set bundled defaults FIRST — ensures the app always has values
      //    even on first launch with no network connection.
      await _remoteConfig.setDefaults(_kRemoteConfigDefaults);

      // 2. Configure fetch behaviour.
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          // In debug mode prefer shorter cache so developers see changes quickly.
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );

      // 3. Fetch + activate in one call. Returns true if new values were activated.
      final updated = await _remoteConfig.fetchAndActivate();
      debugPrint('[RemoteConfigService] fetchAndActivate — updated: $updated');
    } catch (e) {
      // Remote config failures must never crash the app.
      // The app will continue with the bundled default values above.
      debugPrint('[RemoteConfigService] fetchAndActivate failed: $e');
    }
  }

  // ── Typed feature-flag accessors ──────────────────────────────────────────

  /// Whether the Search tab is visible in HomeScreen.
  bool get isSearchEnabled => _remoteConfig.getBool('is_search_enabled');

  /// Welcome banner text shown on the HomeScreen app bar.
  String get welcomeBannerText =>
      _remoteConfig.getString('welcome_banner_text');

  /// Minimum app version required to use the app.
  /// Compare against PackageInfo at runtime to gate access.
  String get minAppVersion => _remoteConfig.getString('min_app_version');
}

// ── Riverpod provider ─────────────────────────────────────────────────────
// DIP: Consumers depend on [RemoteConfigService], not on FirebaseRemoteConfig.
// Use ref.read(remoteConfigServiceProvider) anywhere in the widget tree.
final remoteConfigServiceProvider = Provider<RemoteConfigService>(
  (_) => RemoteConfigService.defaultInstance(),
);
