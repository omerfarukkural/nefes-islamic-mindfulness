import 'package:hive_flutter/hive_flutter.dart';

class OfflineStorageService {
  static const String moodBoxName = 'mood_entries';
  static const String meditationBoxName = 'meditation_sessions';
  static const String settingsBoxName = 'app_settings';
  static const String duaBoxName = 'dua_favorites';
  static const String dreamBoxName = 'dream_journal';
  static const String todosBoxName = 'daily_todos';

  static Future<void> initializeBoxes() async {
    await Hive.openBox(moodBoxName);
    await Hive.openBox(meditationBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(duaBoxName);
    await Hive.openBox(dreamBoxName);
    await Hive.openBox(todosBoxName);
  }

  // ── Mood ──────────────────────────────────────────────────────────────────

  static Future<void> saveMoodEntry(Map<String, dynamic> entry) async {
    final box = Hive.box(moodBoxName);
    await box.add(Map<String, dynamic>.from(entry));
  }

  static List<Map<String, dynamic>> getMoodEntries() {
    final box = Hive.box(moodBoxName);
    return box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList()
      ..sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
  }

  static List<Map<String, dynamic>> getMoodEntriesLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return getMoodEntries().where((e) {
      try {
        return DateTime.parse(e['date'] as String).isAfter(cutoff);
      } catch (_) {
        return false;
      }
    }).toList();
  }

  // ── Meditation ────────────────────────────────────────────────────────────

  static Future<void> saveMeditationSession(Map<String, dynamic> session) async {
    final box = Hive.box(meditationBoxName);
    await box.add(Map<String, dynamic>.from(session));
  }

  static int getTotalMeditationMinutes() {
    final box = Hive.box(meditationBoxName);
    int total = 0;
    for (final s in box.values) {
      final m = s as Map;
      total += (m['duration_minutes'] as int?) ?? 0;
    }
    return total;
  }

  static int getTotalMeditationSessions() {
    return Hive.box(meditationBoxName).length;
  }

  static int getMeditationStreak() {
    final box = Hive.box(meditationBoxName);
    if (box.isEmpty) return 0;

    final sessions = box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList()
      ..sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

    // Collect unique session dates
    final Set<String> dates = {};
    for (final s in sessions) {
      try {
        final d = DateTime.parse(s['date'] as String);
        dates.add('${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}');
      } catch (_) {}
    }

    if (dates.isEmpty) return 0;

    int streak = 0;
    DateTime check = DateTime.now();
    // If no session today, start from yesterday
    final todayKey = '${check.year}-${check.month.toString().padLeft(2, '0')}-${check.day.toString().padLeft(2, '0')}';
    if (!dates.contains(todayKey)) {
      check = check.subtract(const Duration(days: 1));
    }

    while (true) {
      final key = '${check.year}-${check.month.toString().padLeft(2, '0')}-${check.day.toString().padLeft(2, '0')}';
      if (dates.contains(key)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  // ── Dua Favorites ─────────────────────────────────────────────────────────

  static Future<void> toggleDuaFavorite(String duaTitle) async {
    final box = Hive.box(duaBoxName);
    final favorites = box.get('favorites', defaultValue: <dynamic>[]) as List;
    if (favorites.contains(duaTitle)) {
      favorites.remove(duaTitle);
    } else {
      favorites.add(duaTitle);
    }
    await box.put('favorites', favorites);
  }

  static bool isDuaFavorite(String duaTitle) {
    final box = Hive.box(duaBoxName);
    final favorites = box.get('favorites', defaultValue: <dynamic>[]) as List;
    return favorites.contains(duaTitle);
  }

  static List<String> getFavoriteDuas() {
    final box = Hive.box(duaBoxName);
    final favorites = box.get('favorites', defaultValue: <dynamic>[]) as List;
    return favorites.cast<String>();
  }

  // ── Zikir Counter ─────────────────────────────────────────────────────────

  static Future<void> saveZikirSession(String zikirName, int count) async {
    final box = Hive.box(settingsBoxName);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await box.put('zikir_${zikirName}_$today', count);
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  static Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBoxName);
    await box.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(settingsBoxName);
    return box.get(key, defaultValue: defaultValue);
  }

  // ── Dream Journal ─────────────────────────────────────────────────────────

  static Future<void> saveDreamEntry(Map<String, dynamic> entry) async {
    final box = Hive.box(dreamBoxName);
    await box.add(Map<String, dynamic>.from(entry));
  }

  static List<Map<String, dynamic>> getDreamEntries() {
    final box = Hive.box(dreamBoxName);
    return box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList()
      ..sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
  }

  static Future<void> deleteDreamEntry(int index) async {
    final box = Hive.box(dreamBoxName);
    await box.deleteAt(index);
  }

  // ── Daily Todos ───────────────────────────────────────────────────────────

  static Future<void> saveDailyTodos(List<Map<String, dynamic>> todos) async {
    final box = Hive.box(todosBoxName);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await box.put('todos_$today', todos);
  }

  static List<Map<String, dynamic>> getDailyTodos() {
    final box = Hive.box(todosBoxName);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final raw = box.get('todos_$today');
    if (raw == null) return [];
    return (raw as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> toggleTodo(int index) async {
    final todos = getDailyTodos();
    if (index >= 0 && index < todos.length) {
      todos[index]['done'] = !(todos[index]['done'] as bool? ?? false);
      await saveDailyTodos(todos);
    }
  }

  // ── Onboarding ────────────────────────────────────────────────────────────

  static bool hasSeenOnboarding() {
    return getSetting('onboarding_done', defaultValue: false) == true;
  }

  static Future<void> markOnboardingDone() async {
    await saveSetting('onboarding_done', true);
  }
}
