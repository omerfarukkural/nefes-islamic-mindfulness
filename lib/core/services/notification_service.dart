import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
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
}
