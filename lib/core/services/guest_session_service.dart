import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Manages a persistent guest session using SharedPreferences.
/// A guest gets a stable UUID on first use that survives hot restarts and
/// app re-launches, until they explicitly sign out or sign in as a real user.
class GuestSessionService {
  static const String _isGuestKey = 'is_guest_session';
  static const String _guestIdKey = 'guest_user_id';
  static const _uuid = Uuid();

  /// Returns true if the user is currently in a guest session.
  static Future<bool> isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isGuestKey) ?? false;
  }

  /// Returns the persistent guest ID (creates one if it doesn't exist yet).
  static Future<String> getOrCreateGuestId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_guestIdKey);
    if (id == null || id.isEmpty) {
      id = 'guest_${_uuid.v4()}';
      await prefs.setString(_guestIdKey, id);
    }
    return id;
  }

  /// Marks the current session as a guest session and stores a stable guest ID.
  static Future<String> startGuestSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestKey, true);
    return getOrCreateGuestId();
  }

  /// Clears the guest session (called on sign-in or explicit logout).
  static Future<void> clearGuestSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isGuestKey);
    // Note: we keep _guestIdKey so the same guest ID is reused if they
    // log out of a real account and continue as guest again.
  }
}
