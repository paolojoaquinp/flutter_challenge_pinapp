// HU-01: Splash Screen — Riverpod provider that coordinates app initialisation.
// SRP: This notifier is solely responsible for the init sequence;
//      navigation is triggered by the UI reacting to the AsyncValue state.
// DIP: Depends on [RemoteConfigService] abstraction, not on Firebase SDK directly.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/core/remote_config/remote_config_service.dart';

/// State emitted by [SplashNotifier]:
/// - loading  → Splash screen with shimmer
/// - data     → Navigation to HomeScreen
/// - error    → Retry shown on Splash
class SplashNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    await _initialise();
  }

  // Runs Remote Config fetch and a minimum splash delay concurrently.
  // The UI will transition once *both* complete.
  Future<void> _initialise() async {
    final remoteConfig = RemoteConfigService.defaultInstance();
    await Future.wait([
      remoteConfig.fetchAndActivate(),
      Future<void>.delayed(const Duration(seconds: 2)),
    ]);
  }

  /// Allows the user to retry if initialisation fails.
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_initialise);
  }
}

// TODO: review from cawu example notifier
final splashProvider = AsyncNotifierProvider<SplashNotifier, void>(
  SplashNotifier.new,
);
