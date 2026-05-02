import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/services/offline_storage_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _meditationReminder = true;
  bool _prayerReminder = true;
  String _reminderTime = '08:00';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _meditationReminder = OfflineStorageService.getSetting(
          'meditation_reminder', defaultValue: true) as bool? ?? true;
      _prayerReminder = OfflineStorageService.getSetting(
          'prayer_reminder', defaultValue: true) as bool? ?? true;
      _reminderTime = OfflineStorageService.getSetting(
          'reminder_time', defaultValue: '08:00') as String? ?? '08:00';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Bildirimler'),
          SwitchListTile(
            title: const Text('Meditasyon Hatırlatıcı'),
            subtitle: const Text('Günlük meditasyon hatırlatması'),
            value: _meditationReminder,
            onChanged: (v) {
              setState(() => _meditationReminder = v);
              OfflineStorageService.saveSetting('meditation_reminder', v);
            },
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            title: const Text('Namaz Vakti Bildirimi'),
            subtitle: const Text('Namaz vakti geldiğinde bildirim'),
            value: _prayerReminder,
            onChanged: (v) {
              setState(() => _prayerReminder = v);
              OfflineStorageService.saveSetting('prayer_reminder', v);
            },
            activeColor: AppColors.primary,
          ),
          ListTile(
            title: const Text('Hatırlatma Saati'),
            subtitle: Text(_reminderTime),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final parts = _reminderTime.split(':');
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: int.tryParse(parts[0]) ?? 8,
                  minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
                ),
              );
              if (time != null && mounted) {
                final formatted =
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                setState(() => _reminderTime = formatted);
                OfflineStorageService.saveSetting('reminder_time', formatted);
              }
            },
          ),
          const Divider(),
          _buildSectionHeader('Görünüm'),
          SwitchListTile(
            title: const Text('Karanlık Mod'),
            subtitle: const Text('Gece modu için karanlık tema'),
            value: isDarkMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setDarkMode(v),
            activeColor: AppColors.primary,
          ),
          const Divider(),
          _buildSectionHeader('Premium'),
          ListTile(
            leading: Icon(Icons.star, color: AppColors.accent),
            title: const Text('Premium\'a Yükselt'),
            subtitle: const Text('Reklamsız deneyim + tüm içerikler'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/paywall'),
          ),
          const Divider(),
          _buildSectionHeader('Hakkında'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versiyon'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Bir Tebessüm Bin Mutluluk Derneği'),
            subtitle: const Text('Bu uygulama derneğimiz tarafından geliştirilmiştir'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          )),
    );
  }
}
