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
    return box.values.cast<Map<String, dynamic>>().toList();
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
      total += (session['duration_minutes'] as int?) ?? 0;
    }
    return total;
  }

  static int getMeditationStreak() {
    final box = Hive.box(meditationBoxName);
    if (box.isEmpty) return 0;
    // Calculate streak logic
    int streak = 0;
    DateTime checkDate = DateTime.now();
    final sessions = box.values.toList();
    sessions.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    
    for (var session in sessions) {
      final sessionDate = DateTime.parse(session['date'] as String);
      if (sessionDate.day == checkDate.day &&
          sessionDate.month == checkDate.month &&
          sessionDate.year == checkDate.year) {
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
}
