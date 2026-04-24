// ADR-004: SharedPreferences is used exclusively for simple boolean/string flags.
// Collections of objects belong in Hive. This keeps each storage concern isolated.
// SRP: This class is solely responsible for reading and writing simple flag values.
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used for SharedPreferences entries — centralised to prevent typos.
class _PrefKeys {
  _PrefKeys._();
  static const String hasSeenOnboarding = 'has_seen_onboarding';
}

/// Typed facade over [SharedPreferences] for simple flag persistence.
class SharedPrefsService {
  final SharedPreferences _prefs;

  const SharedPrefsService(this._prefs);

  // ── Onboarding flag ───────────────────────────────────────────────────────

  bool get hasSeenOnboarding =>
      _prefs.getBool(_PrefKeys.hasSeenOnboarding) ?? false;

  Future<void> setHasSeenOnboarding({required bool value}) =>
      _prefs.setBool(_PrefKeys.hasSeenOnboarding, value);

  // ── Utility ───────────────────────────────────────────────────────────────

  /// Clears all stored flags. Useful for logout / account reset flows.
  Future<void> clearAll() => _prefs.clear();
}
