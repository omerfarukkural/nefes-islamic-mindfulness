import 'package:hive_flutter/hive_flutter.dart';

class OfflineStorageService {
  static const String moodBoxName = 'mood_entries';
  static const String meditationBoxName = 'meditation_sessions';
  static const String settingsBoxName = 'app_settings';
  static const String duaBoxName = 'dua_favorites';

  static Future<void> initializeBoxes() async {
    await Hive.openBox(moodBoxName);
    await Hive.openBox(meditationBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(duaBoxName);
  }

  // Mood Entries
  static Future<void> saveMoodEntry(Map<String, dynamic> entry) async {
    final box = Hive.box(moodBoxName);
    await box.add(entry);
  }

  static List<Map<String, dynamic>> getMoodEntries() {
    final box = Hive.box(moodBoxName);
    return box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // Meditation Sessions
  static Future<void> saveMeditationSession(Map<String, dynamic> session) async {
    final box = Hive.box(meditationBoxName);
    await box.add(session);
  }

  static int getTotalMeditationMinutes() {
    final box = Hive.box(meditationBoxName);
    int total = 0;
    for (var session in box.values) {
      total += (Map<String, dynamic>.from(session as Map)['duration_minutes'] as int?) ?? 0;
    }
    return total;
  }

  static int getMeditationSessionCount() {
    return Hive.box(meditationBoxName).length;
  }

  static int getMeditationStreak() {
    final box = Hive.box(meditationBoxName);
    if (box.isEmpty) return 0;

    // Benzersiz günleri bul
    final uniqueDays = <String>{};
    for (var session in box.values) {
      final dateStr = (Map<String, dynamic>.from(session as Map)['date'] as String?) ?? '';
      if (dateStr.isNotEmpty) {
        try {
          final date = DateTime.parse(dateStr);
          uniqueDays.add('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
        } catch (_) {}
      }
    }

    final sortedDays = uniqueDays.toList()..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (final dayStr in sortedDays) {
      final parts = dayStr.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      if (day == checkDate.day &&
          month == checkDate.month &&
          year == checkDate.year) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  // Settings
  static Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBoxName);
    await box.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(settingsBoxName);
    return box.get(key, defaultValue: defaultValue);
  }

  // Dua Favorites
  static List<int> getDuaFavorites() {
    final box = Hive.box(duaBoxName);
    final favs = box.get('favorites', defaultValue: <dynamic>[]);
    return List<int>.from(favs as List);
  }

  static Future<void> toggleDuaFavorite(int duaId) async {
    final box = Hive.box(duaBoxName);
    final favs = List<int>.from(
        (box.get('favorites', defaultValue: <dynamic>[]) as List));
    if (favs.contains(duaId)) {
      favs.remove(duaId);
    } else {
      favs.add(duaId);
    }
    await box.put('favorites', favs);
  }
}
