import 'package:shared_preferences/shared_preferences.dart';

class LivesService {
  static const int maxLives = 5;

  static const String _livesKey = 'player_lives';
  static const String _lastLifeTimeKey =
      'last_life_time_utc';

  static const String _unlimitedUntilKey =
      'unlimited_lives_until_utc';

  /// Get current lives.
  static Future<int> getLives() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(_livesKey) ?? maxLives;
  }

  /// Save lives.
  static Future<void> setLives(
    int lives,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final safeLives =
        lives.clamp(0, maxLives);

    await prefs.setInt(
      _livesKey,
      safeLives,
    );

    if (safeLives < maxLives) {
      final existing =
          prefs.getInt(_lastLifeTimeKey);

      if (existing == null) {
        await prefs.setInt(
          _lastLifeTimeKey,
          DateTime.now()
              .toUtc()
              .millisecondsSinceEpoch,
        );
      }
    } else {
      await prefs.remove(
        _lastLifeTimeKey,
      );
    }
  }

  /// Use one life before starting a level.
  ///
  /// Returns false if the player has no life
  /// and does not have Unlimited Lives.
  static Future<bool> useLife() async {
    if (await isUnlimitedLives()) {
      return true;
    }

    await _restoreAvailableLives();

    final lives = await getLives();

    if (lives <= 0) {
      return false;
    }

    await setLives(lives - 1);

    return true;
  }

  /// Restore lives according to the 2-hour timer.
  ///
  /// This uses the last trusted UTC timestamp
  /// saved by the app.
  static Future<int> _restoreAvailableLives() async {
    if (await isUnlimitedLives()) {
      return maxLives;
    }

    final prefs =
        await SharedPreferences.getInstance();

    int lives =
        prefs.getInt(_livesKey) ?? maxLives;

    if (lives >= maxLives) {
      return maxLives;
    }

    final lastTime =
        prefs.getInt(_lastLifeTimeKey);

    if (lastTime == null) {
      await prefs.setInt(
        _lastLifeTimeKey,
        DateTime.now()
            .toUtc()
            .millisecondsSinceEpoch,
      );

      return lives;
    }

    final now =
        DateTime.now()
            .toUtc()
            .millisecondsSinceEpoch;

    final elapsed =
        now - lastTime;

    const twoHours =
        2 * 60 * 60 * 1000;

    final restoredLives =
        elapsed ~/ twoHours;

    if (restoredLives <= 0) {
      return lives;
    }

    final newLives =
        (lives + restoredLives)
            .clamp(0, maxLives);

    if (newLives >= maxLives) {
      await prefs.remove(
        _lastLifeTimeKey,
      );
    } else {
      final remainingPeriods =
          restoredLives;

      final newLastTime =
          lastTime +
              (remainingPeriods *
                  twoHours);

      await prefs.setInt(
        _lastLifeTimeKey,
        newLastTime,
      );
    }

    await prefs.setInt(
      _livesKey,
      newLives,
    );

    return newLives;
  }

  /// Public method for refreshing lives.
  static Future<int> refreshLives() async {
    return _restoreAvailableLives();
  }

  /// Check whether Unlimited Lives is active.
  static Future<bool> isUnlimitedLives() async {
    final prefs =
        await SharedPreferences.getInstance();

    final expiry =
        prefs.getInt(
      _unlimitedUntilKey,
    );

    if (expiry == null) {
      return false;
    }

    final now =
        DateTime.now()
            .toUtc()
            .millisecondsSinceEpoch;

    if (now < expiry) {
      return true;
    }

    await prefs.remove(
      _unlimitedUntilKey,
    );

    return false;
  }

  /// Activate Unlimited Lives for 6 hours.
  ///
  /// Actual $0.99 payment will be connected
  /// through Google Play Billing later.
  static Future<void>
      activateUnlimitedLives() async {
    final prefs =
        await SharedPreferences.getInstance();

    final now =
        DateTime.now()
            .toUtc();

    final expiry =
        now.add(
      const Duration(hours: 6),
    );

    await prefs.setInt(
      _unlimitedUntilKey,
      expiry.millisecondsSinceEpoch,
    );
  }

  /// Remaining time for Unlimited Lives.
  static Future<Duration>
      getUnlimitedRemainingTime() async {
    final prefs =
        await SharedPreferences.getInstance();

    final expiry =
        prefs.getInt(
      _unlimitedUntilKey,
    );

    if (expiry == null) {
      return Duration.zero;
    }

    final now =
        DateTime.now()
            .toUtc()
            .millisecondsSinceEpoch;

    final remaining =
        expiry - now;

    if (remaining <= 0) {
      await prefs.remove(
        _unlimitedUntilKey,
      );

      return Duration.zero;
    }

    return Duration(
      milliseconds: remaining,
    );
  }

  /// Add one life.
  ///
  /// Used later for rewarded ads,
  /// daily rewards, friends, etc.
  static Future<bool> addLife() async {
    if (await isUnlimitedLives()) {
      return true;
    }

    await _restoreAvailableLives();

    final lives = await getLives();

    if (lives >= maxLives) {
      return false;
    }

    await setLives(lives + 1);

    return true;
  }

  /// Add multiple lives.
  static Future<void> addLives(
    int amount,
  ) async {
    if (amount <= 0) return;

    if (await isUnlimitedLives()) {
      return;
    }

    await _restoreAvailableLives();

    final lives = await getLives();

    await setLives(
      (lives + amount)
          .clamp(0, maxLives),
    );
  }

  /// Reset lives to 5.
  static Future<void> resetLives() async {
    await setLives(maxLives);
  }

  /// Time remaining before the next
  /// automatic life refill.
  static Future<Duration>
      getNextLifeRemainingTime() async {
    if (await isUnlimitedLives()) {
      return Duration.zero;
    }

    final prefs =
        await SharedPreferences.getInstance();

    final lives =
        prefs.getInt(_livesKey) ?? maxLives;

    if (lives >= maxLives) {
      return Duration.zero;
    }

    final lastTime =
        prefs.getInt(_lastLifeTimeKey);

    if (lastTime == null) {
      return const Duration(hours: 2);
    }

    final now =
        DateTime.now()
            .toUtc()
            .millisecondsSinceEpoch;

    const twoHours =
        2 * 60 * 60 * 1000;

    final nextTime =
        lastTime + twoHours;

    final remaining =
        nextTime - now;

    if (remaining <= 0) {
      await _restoreAvailableLives();

      return getNextLifeRemainingTime();
    }

    return Duration(
      milliseconds: remaining,
    );
  }
}
