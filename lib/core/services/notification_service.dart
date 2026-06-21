import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  static Future<void> scheduleDailyMeditationReminder({
    required int hour,
    required int minute,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'meditation_channel',
      'Meditasyon Hatırlatıcı',
      channelDescription: 'Günlük meditasyon hatırlatmaları',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    final now = DateTime.now();
    var scheduledDate =
        DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.periodicallyShow(
      0,
      '🧘 Nefes Zamanı',
      'Bugünkü meditasyonunu yapmayı unutma. Birkaç dakika kendine ayır.',
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> showMeditationReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'meditation_channel',
      'Meditasyon Hatırlatıcı',
      channelDescription: 'Günlük meditasyon hatırlatmaları',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(
      0,
      '🧘 Nefes Zamanı',
      'Bugünkü meditasyonunu yapmayı unutma. Birkaç dakika kendine ayır.',
      details,
    );
  }

  static Future<void> showPrayerReminder(String prayerName) async {
    const androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Namaz Hatırlatıcı',
      channelDescription: 'Namaz vakti hatırlatmaları',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(
      1,
      '🕌 $prayerName Vakti',
      '$prayerName namazı vakti geldi. Haydi namaza!',
      details,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
